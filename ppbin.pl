#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;


# typedef struct _Header_
# {
# 	char			szMagic[6];			//	Magic string "IP-CAM"
# 	unsigned char	nMediaType;			//	1: Video, 2: Audio
# 	unsigned char	nCodingType;		//	For Video < 0: I-VOP 1: P-VOP 5: JPEG >  For Audio < 1: PCM, 2: ADPCM >
# 	unsigned long   uDataLength;		//	Raw Data Length
# 	unsigned long	uSequenceNumber;	//	Frame Seq No
# 	unsigned long	dwTimeSec;			//	TimeStamp in sec since 1970/01/01 00:00
# 	unsigned short	dwTimeuSec;			// 	TimeStamp ms part
# 	unsigned short 	wAudioSampleRate;	//	Audio Sample Rate
# 	unsigned short 	wAudioSampleBits;	//	Audio Sample Bits
# 	unsigned short 	nWidth;				//	Video Frame Width
# 	unsigned short 	nHeight;			//	Video Frame Height
# 	unsigned short	nFPS;				//	Video Frame per sec
# 	unsigned char	nDataCheckSum;		//	Raw Data Check (Last Byte)
# 	unsigned char	nMDWinCount;		//	Motion Detection Window Count
# 	unsigned char	nReserved[2];
# 	unsigned char   MD_bitmap[8];
# 	unsigned char	MD_power[64];
# }HEADER, *pHEADER;

use File::Binary qw($BIG_ENDIAN $LITTLE_ENDIAN $NATIVE_ENDIAN);

my $video_file = "/home/richard/programming/perl/video_conv/recored_out_1.bin";

my $fb = File::Binary->new($video_file);

$fb->get_ui8();
$fb->get_ui16();
$fb->get_ui32();
$fb->get_si8();
$fb->get_si16();
$fb->get_si32();

$fb->close();

$fb->open(">newfile");

$fb->put_ui8(255);
$fb->put_ui16(65535);
$fb->put_ui32(4294967295);
$fb->put_si8(-127);
$fb->put_si16(-32767);
$fb->put_si32(-2147483645);

$fb->close();


$fb->open(IO::Scalar->new($somedata));
$fb->set_endian($BIG_ENDIAN); # force endianness

# do what they say on the tin
$fb->seek($pos);
$fb->tell();
