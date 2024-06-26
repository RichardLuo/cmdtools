#class XBuildModuleInfo
package XBuildModuleInfo;
use strict;

use XBuild::Utils;

#constructor
sub new {
  my ($class) = @_;
  my $self =
    {
     _exename           => "",
     _libname           => "",
     _code_type         => undef,
     _code_head         => undef,
     _code_body         => undef,
    };

  bless $self, $class;
  return $self;
}

sub append_code_body {
  my ($self, $code) = @_;
  push(@{$self->{'_code_body'}}, $code) if defined($code);
}

sub append_exename {
  my ($self, $name) = @_;
  $self->{'_exename'} = $self->{'_exename'} . ' ' . $name if defined($name);
  $self->{'_exename'} =~ s/\s+$//;
  $self->{'_exename'} =~ s/^\s+//;
  printf "=== exename: [%s]\n", $self->{'_exename'};
}

sub set_exename {
  my ($self, $name) = @_;
  $self->{'_exename'} = $name if defined($name);
  $self->{'_exename'} =~ s/\s+$//;
  $self->{'_exename'} =~ s/^\s+//;
}

sub get_exename {
  my ($self) = @_;
  return defined($self->{'_exename'}) ? $self->{'_exename'} : "";
}

sub get_libname {
  my ($self) = @_;
  return defined($self->{'_libname'}) ? $self->{'_libname'} : "";
}

sub get_codetype {
  my ($self) = @_;
  return defined($self->{'_code_type'}) ? $self->{'_code_type'} : "";
}

sub set_libname {
  my ($self, $name) = @_;
  $self->{'_libname'} = $name if defined($name);
}

sub set_codetype {
  my ($self, $type) = @_;
  $self->{'_code_type'} = $type if defined($type);
}

my $time_stamp = localtime();
my $makefile_header .= <<___;
################################################################
# This file is auto generated by XBuild tools
# You can modify it manually for customization.
#
# $time_stamp
################################################################

___

sub parse_makefile {
  my ($self, $path) = @_;

  open(LMKFile, "< $path") or die "can not open local $path";

  my $state = "head";
  foreach my $line (<LMKFile>) {
    chop $line;
    if ($line =~ /^\s*EXENAME\s*:?=\s*(\w+.*\b)\s*$/) {
      printf "local: [%s]\n", $1;
      $self->{'_exename'} = $1;
    }
    elsif ($line =~ /^\s*LIBNAME\s*:?=\s*(\w+.*\b)\s*$/) {
      print "local: $line \n";
      $self->{'_libname'} = $1;
      $state = "body";
    }
    elsif ($line =~ /^\s*CODE_TYPE\s*:?=\s*(\w+\b)\s*$/) {
      print "local: $line \n";
      $self->{'_code_type'} = $1;
      $state = "body";
    }
    else {
      if ($state eq "head") {
        push @{$self->{'_code_head'}}, $line;
      }
      elsif ($state eq "body") {
        push @{$self->{'_code_body'}}, $line;
      }
    }
  }
  close(LMKFile);

  if (defined($self->{'_exename'}) || defined($self->{'_libname'})) {
    return 1;
  }
  return 0;
}

sub self_dump {
  my ($self) = @_;
  Utils::print_array(@{$self->{'_code_head'}}) if defined @{$self->{'_code_head'}};
  printf("_exename:[%s]\n", $self->{'_exename'}) if defined $self->{'_exename'};
  printf("_libname:[%s]\n", $self->{'_libname'}) if defined $self->{'_libname'};
  printf("_code_type:[%s]\n", $self->{'_code_type'}) if defined $self->{'_code_type'};
  Utils::print_array(@{$self->{'_code_body'}}) if defined @{$self->{'_code_body'}};
}

sub gen_android_makefile {
  my ($self) = @_;
  open(OutFile, ">Android.mk") || die("Cannot open Android.mk\n");
  print OutFile $makefile_header;
  print OutFile "LOCAL_MODULE := " . $self->{_local_module} . "\n";
  print OutFile "LOCAL_SRC_FILES := " . $self->{_local_src_files} . "\n";

#  print OutFile "body := " . $self->{_local_code_body} . "\n";
  # print OutFile "body := " . $_local_code_body . "\n";

  foreach my $lc (@$self->{'_code_body'}) {
    print OutFile $lc;
  }

  printf OutFile "\ninclude \$(%s)\n", $self->{_local_build_type};
  close OutFile;
}

sub gen_xbuild_makefile {
  my ($self, $path) = @_;
  open(OutFile, ">$path") || die("Cannot open $path\n");
  printf OutFile "%s", $makefile_header;
  printf OutFile "EXENAME := %s\n", $self->{'_exename'} if $self->{'_exename'} ne "";
  printf OutFile "LIBNAME := %s\n", $self->{'_libname'} if $self->{'_libname'} ne "";
  printf OutFile "CODE_TYPE := %s\n", $self->{'_code_type'} if defined $self->{'_code_type'};

  if (defined(@{$self->{'_code_body'}}) && @{$self->{'_code_body'}} > 0) {
    foreach my $lc (@$self->{'_code_body'}) {
      printf OutFile "%s\n", $lc;
    }
  } else {
    printf OutFile "\n%s\n", "include \$(HOMESYS_ROOT)/kkbuild/common.mk";
  }

  close OutFile;
}



1;
