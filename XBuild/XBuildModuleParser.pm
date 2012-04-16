#class XBuildModuleParser
package XBuildModuleParser;

use strict;
use diagnostics;
use XBuild::Utils;
use File::Copy;
use File::Basename;
use XBuild::XBuildModuleInfo;

#constructor
sub new {
  my $class = shift;
  my $self =
    {
     module_info_       => undef,
     module_path_       => undef,
     source_files_      => undef,
     lib_source_files_  => undef,
     header_files_      => undef,
     main_entry_files_  => undef,
     test_entry_files_  => undef,
     app_entry_files_   => undef,
     source_directory_  => undef,
     header_directory_  => undef,
     gen_makefile_      => undef,
    };

  bless $self, $class;
  return $self;
}

our($module_path_, @source_files_, @header_files_, @lib_source_files_, $gen_makefile_,
    @main_entry_files_, @_unit_test_files, $source_directory_, $header_directory_, @test_entry_files_, @app_entry_files_,
   );


sub set_module_info {
  my ($self, $mi) = @_;
  $self->{'module_info_'} = $mi if defined $mi;
}

sub classify_main_entry_files {
  my ($self) = shift;
  if (@main_entry_files_ <= 0) {
    print "there is no main entry file \n";
    return;
  }

  foreach my $f (@main_entry_files_) {
    my $bkname = $f;
    my $basename = basename $f;
    (my $filename = $basename) =~ s/\.[^.]+$//;
    if ($filename =~ /^test/ ||
        $filename =~ /^t_/ ) {
      push @test_entry_files_, $f;
    }
    else {
      push @app_entry_files_, $f;
      $self->{'module_info_'}->append_exename($filename);
    }
  }
}


sub parse_all_files {
  my ($self) = @_;

  foreach my $file (@source_files_) {
    my $dst_dir = ($file =~ /\.cp{0,2}$/) ? $source_directory_ : $header_directory_;
    my $cmd = sprintf("mv %18s%18s", $file, $dst_dir);
    if (Utils::has_main_entry($file)) {
      push @main_entry_files_, $file;
    } else {
      push @lib_source_files_, $file;
    }
  }
}


sub parse {
  my ($self, $path) = @_;

  print "source_directory_:\t$source_directory_ \n";
  print "header_directory_:\t$header_directory_ \n";

  $module_path_ = $path if defined($path);
  $self->parse_all_files;
  $self->classify_main_entry_files;
  my $libname = "lib" . Utils::get_base_local_module_name($path) . ".a";
  $self->{'module_info_'}->set_libname($libname);

  my $lmk_module = new XBuildModuleInfo();
  my $lmk_file = "$path/Makefile";
  $gen_makefile_ = 1;
  if (-f $lmk_file) {
    if ($lmk_module->parse_makefile($lmk_file) ) {
      if ($lmk_module->get_exename() ne "" &&
          $lmk_module->get_exename() eq $self->{'module_info_'}->get_exename() ) {
        print "lmk's exename already exist and equal to module_info_'s exename,\nit doesn't need to re-generate the local Makefile \n";
        printf "module_info_->get_exename:%s\n",$self->{'module_info_'}->get_exename();
        $gen_makefile_ = 0;
      } else {
        print "lmk's exename not equal to module_info_'s, need to generate the $lmk_file \n";
        printf "H: module_info_->get_exename:[%s]\n", $self->{'module_info_'}->get_exename();
      }

      if ($lmk_module->get_libname() ne "") {
          if ($lmk_module->get_exename() eq "") {
            print "lmk's libname already exists, and module_info_'s exename is empty,\nso it doesn't need to re-generate the local Makefile \n";
            $gen_makefile_ = 0;
          }
          else {
            $self->{'module_info_'}->set_libname($lmk_module->get_libname());
          }
      }
    }
  }
  return $gen_makefile_;
}

sub execute_gen_xbuild_makefile {
  my ($self) = @_;

  if (defined(@header_files_) && @header_files_ > 0) {
    print "before mkdir \n";
    mkdir $header_directory_, 0755;
    foreach my $h (@header_files_) {
      move($h, $header_directory_) or die "error while moving files:$@";
    }
  }

  if (defined(@lib_source_files_) && @lib_source_files_ > 0) {
    mkdir $source_directory_, 0755;
    foreach my $s (@lib_source_files_) {
      print "before move($s, $source_directory_) \n";
      move($s, $source_directory_) or die "error while moving files:$@";
    }
  }

  my $local_mkfile = $module_path_ . "/Makefile";
  if ($gen_makefile_ == 1) {
    if ( -f $local_mkfile) {
      Utils::backup_file("$ENV{PWD}/Makefile");
    }
    $self->{'module_info_'}->gen_xbuild_makefile($local_mkfile);
  }
  else {
    print "Doesn't need to genereate the $local_mkfile \n";
  }
}

sub set_directories {
  my ($self, $src, $inc) = @_;

  $source_directory_ = $src if defined($src);
  $header_directory_ = $inc if defined($inc);
}

sub set_source_files {
  my ($self, $files) = @_;

  foreach my $f (@$files) {
    push(@source_files_, $f);
    # print "pushed $f \n";
  }
  # print "++++++++++++++++ \n";
  # Utils::print_array @source_files_;
  # print "++++++++++++++++ \n";
}

sub set_header_files {
  my ($self, $files) = @_;
  foreach my $f (@$files) {
    push(@header_files_, $f);
  }
}

sub app_entry_files {
  my ($self) = @_;
  return @app_entry_files_;
}

sub test_entry_files {
  my ($self) = @_;
  return @test_entry_files_;
}

sub lib_source_files {
  my ($self) = @_;
  return @lib_source_files_;
}


sub dprint {
  my ($self) = @_;

#   print "source files:\t@source_files_ \n" if  @source_files_ > 0;
#   print "header files:\t@header_files_ \n" if @header_files_ > 0;
#   print "unit test files:\t@test_entry_files_ \n" if @test_entry_files_ > 0;
#   print "main entry files:\t@main_entry_files_ \n" if @main_entry_files_ > 0;
#   print "app entry files:\t@app_entry_files_ \n" if @app_entry_files_ > 0;
#   print "lib source files:\t@lib_source_files_ \n";

}


1;
