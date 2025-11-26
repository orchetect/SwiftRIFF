//
//  WAVFile Encoding.swift
//  swift-riff • https://github.com/orchetect/swift-riff
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension WAVFile {
    /// WAV file data encoding.
    ///
    /// This table is derived from https://www.recordingblogs.com/wiki/format-chunk-of-a-wave-file
    public enum Encoding: UInt16 {
        case unknown = 0x0000
        case microsoft_PCM = 0x0001
        case microsoft_ADPCM = 0x0002
        case microsoft_IEEE_float = 0x0003
        case compaqVSELP = 0x0004
        case iBMCVSD = 0x0005
        case iTU_G_711_aLaw = 0x0006
        case iTU_G_711_uLaw = 0x0007
        case microsoft_DTS = 0x0008
        case drm = 0x0009
        case wma_9_Speech = 0x000A
        case microsoft_Windows_Media_RT_Voice = 0x000B
        case oki_ADPCM = 0x0010
        case intel_IMA_DVI_ADPCM = 0x0011
        case videologic_Mediaspace_ADPCM = 0x0012
        case sierraADPCM = 0x0013
        case antex_G_723_ADPCM = 0x0014
        case dsp_Solutions_DIGISTD = 0x0015
        case dsp_Solutions_DIGIFIX = 0x0016
        case dialogic_OKI_ADPCM = 0x0017
        case media_Vision_ADPCM = 0x0018
        case hp_CU = 0x0019
        case hp_Dynamic_Voice = 0x001A
        case yamaha_ADPCM = 0x0020
        case sonarc_Speech_Compression = 0x0021
        case dsp_Group_True_Speech = 0x0022
        case echo_Speech_Corp = 0x0023
        case virtual_Music_Audiofile_AF36 = 0x0024
        case audio_Processing_Tech = 0x0025
        case virtual_Music_Audiofile_AF10 = 0x0026
        case aculab_Prosody_1612 = 0x0027
        case merging_Tech_LRC = 0x0028
        case dolby_AC2 = 0x0030
        case microsoft_GSM610 = 0x0031
        case msn_Audio = 0x0032
        case antex_ADPCM = 0x0033
        case control_Resources_VQLPC = 0x0034
        case dsp_Solutions_DIGIREAL = 0x0035
        case dsp_Solutions_DIGIADPCM = 0x0036
        case control_Resources_CR10 = 0x0037
        case natural_MicroSystems_VBX_ADPCM = 0x0038
        case crystal_Semiconductors_IMA_ADPCM = 0x0039
        case echo_Speech_ECHOSC3 = 0x003A
        case rockwell_ADPCM = 0x003B
        case rockwell_DIGITALK = 0x003C
        case xebec_Multimedia = 0x003D
        case antex_G_721_ADPCM = 0x0040
        case antex_G_728_CELP = 0x0041
        case microsoft_MSG723 = 0x0042
        case ibm_AVC_ADPCM = 0x0043
        case itu_T_G_726 = 0x0045
        case microsoft_MPEG = 0x0050
        case rt23_or_PAC = 0x0051
        case inSoft_RT24 = 0x0052
        case inSoft_PAC = 0x0053
        case mp3 = 0x0055
        case cirrus = 0x0059
        case cirrus_Logic = 0x0060
        case ess_Tech_PCM = 0x0061
        case voxware_Inc = 0x0062
        case canopus_ATRAC = 0x0063
        case apicom_G_726_ADPCM = 0x0064
        case apicom_G_722_ADPCM = 0x0065
        case microsoft_DSAT = 0x0066
        case microsoft_DSAT_DISPLAY = 0x0067
        case voxware_Byte_Aligned = 0x0069
        case voxware_ACB = 0x0070
        case voxware_AC10 = 0x0071
        case voxware_AC16 = 0x0072
        case voxware_AC20 = 0x0073
        case voxware_MetaVoice = 0x0074
        case voxware_MetaSound = 0x0075
        case voxware_RT29HW = 0x0076
        case voxware_VR12 = 0x0077
        case voxware_VR18 = 0x0078
        case voxware_TQ40 = 0x0079
        case voxware_SC3 = 0x007A
        case voxware_SC3_2 = 0x007B
        case soundsoft = 0x0080
        case voxware_TQ60 = 0x0081
        case microsoft_MSRT24 = 0x0082
        case aTandT_G_729A = 0x0083
        case motion_Pixels_MVI_MV12 = 0x0084
        case dataFusion_G_726 = 0x0085
        case dataFusion_GSM610 = 0x0086
        case iterated_Systems_Audio = 0x0088
        case onlive = 0x0089
        case multitudeInc_FT_SX20 = 0x008A
        case infocom_ITS_AS_G_721_ADPCM = 0x008B
        case convedia_G729 = 0x008C
        case congruencyInc_not_specified = 0x008D
        case siemens_SBC24 = 0x0091
        case sonic_Foundry_Dolby_AC3_APDIF = 0x0092
        case mediaSonic_G_723 = 0x0093
        case aculab_Prosody_8kbps = 0x0094
        case zyXEL_ADPCM = 0x0097
        case philips_LPCBB = 0x0098
        case studer_Professional_Audio_Packed = 0x0099
        case maiden_PhonyTalk = 0x00A0
        case racal_Recorder_GSM = 0x00A1
        case racal_Recorder_G720_a = 0x00A2
        case racal_G723_1 = 0x00A3
        case racal_Tetra_ACELP = 0x00A4
        case nec_AAC_NEC_Corporation = 0x00B0
        case aac = 0x00FF
        case rhetorex_ADPCM = 0x0100
        case ibm_uLaw = 0x0101
        case ibm_aLaw = 0x0102
        case ibm_ADPCM = 0x0103
        case vivo_G_723 = 0x0111
        case vivo_Siren = 0x0112
        case philips_Speech_Processing_CELP = 0x0120
        case philips_Speech_Processing_GRUNDIG = 0x0121
        case digital_G_723 = 0x0123
        case sanyo_LD_ADPCM = 0x0125
        case sipro_Lab_ACEPLNET = 0x0130
        case sipro_Lab_ACELP4800 = 0x0131
        case sipro_Lab_ACELP8V3 = 0x0132
        case sipro_Lab_G_729 = 0x0133
        case sipro_Lab_G_729A = 0x0134
        case sipro_Lab_Kelvin = 0x0135
        case voiceAge_AMR = 0x0136
        case dictaphone_G_726_ADPCM = 0x0140
        case qualcomm_PureVoice = 0x0150
        case qualcomm_HalfRate = 0x0151
        case ring_Zero_Systems_TUBGSM = 0x0155
        case microsoft_Audio1 = 0x0160
        case windows_Media_Audio_V2_V7_V8_V9_DivX = 0x0161
        case windows_Media_Audio_Professional_V9 = 0x0162
        case windows_Media_Audio_Lossless_V9 = 0x0163
        case wMA_Pro_over_SPDIF = 0x0164
        case uNISYS_NAP_ADPCM = 0x0170
        case uNISYS_NAP_ULAW = 0x0171
        case uNISYS_NAP_ALAW = 0x0172
        case uNISYS_NAP_16K = 0x0173
        case mm_SYCOM_ACM_SYC008_SyCom_Technologies = 0x0174
        case mm_SYCOM_ACM_SYC701_G726L_SyCom_Technologies = 0x0175
        case mm_SYCOM_ACM_SYC701_CELP54_SyCom_Technologies = 0x0176
        case mm_SYCOM_ACM_SYC701_CELP68_SyCom_Technologies = 0x0177
        case knowledge_Adventure_ADPCM = 0x0178
        case fraunhofer_IIS_MPEG2AAC = 0x0180
        case digital_Theater_Systems_DTS_DS = 0x0190
        case creative_Labs_ADPCM = 0x0200
        case creative_Labs_FASTSPEECH8 = 0x0202
        case creative_Labs_FASTSPEECH10 = 0x0203
        case uher_ADPCM = 0x0210
        case ulead_DV_ACM = 0x0215
        case ulead_DV_ACM_2 = 0x0216
        case quarterdeck_Corp = 0x0220
        case iLink_VC = 0x0230
        case aureal_Semiconductor_Raw_Sport = 0x0240
        case esst_AC3 = 0x0241
        case interactive_Products_HSX = 0x0250
        case interactive_Products_RPELP = 0x0251
        case consistent_CS2 = 0x0260
        case sony_SCX = 0x0270
        case sony_SCY = 0x0271
        case sony_ATRAC3 = 0x0272
        case sony_SPC = 0x0273
        case telum_Telum_Inc = 0x0280
        case telumia_Telum_Inc = 0x0281
        case norcom_Voice_Systems_ADPCM = 0x0285
        case fujitsu_FM_TOWNS_SND = 0x0300
        case fujitsu_not_specified1 = 0x0301
        case fujitsu_not_specified2 = 0x0302
        case fujitsu_not_specified3 = 0x0303
        case fujitsu_not_specified4 = 0x0304
        case fujitsu_not_specified5 = 0x0305
        case fujitsu_not_specified6 = 0x0306
        case fujitsu_not_specified7 = 0x0307
        case fujitsu_not_specified8 = 0x0308
        case micronas_Semiconductors_Inc_Development = 0x0350
        case micronas_Semiconductors_Inc_CELP833 = 0x0351
        case brooktree_Digital = 0x0400
        case intel_Music_Coder_IMC = 0x0401
        case ligos_Indeo_Audio = 0x0402
        case qDesign_Music = 0x0450
        case on2_VP7_On2_Technologies = 0x0500
        case on2_VP6_On2_Technologies = 0x0501
        case aTandT_VME_VMPCM = 0x0680
        case aTandT_TCP = 0x0681
        case ympeg_Alpha_dummy_for_MPEG2_compressor = 0x0700
        case clearJump_LiteWave_lossless = 0x08AE
        case olivetti_GSM = 0x1000
        case olivetti_ADPCM = 0x1001
        case olivetti_CELP = 0x1002
        case olivetti_SBC = 0x1003
        case olivetti_OPR = 0x1004
        case lernoutAndHauspie = 0x1100
        case lernoutAndHauspie_CELP_codec = 0x1101
        case lernoutAndHauspie_SBC_codec = 0x1102
        case lernoutAndHauspie_SBC_codec_2 = 0x1103
        case lernoutAndHauspie_SBC_codec_3 = 0x1104
        case norris_Comm_Inc = 0x1400
        case isiAudio = 0x1401
        case aTandT_Soundspace_Music_Compression = 0x1500
        case voxWare_RT24_speech_codec = 0x181C
        case lucent_elemedia_AX24000P_Music_codec = 0x181E
        case sonic_Foundry_LOSSLESS = 0x1971
        case innings_Telecom_Inc_ADPCM = 0x1979
        case lucent_SX8300P_speech_codec = 0x1C07
        case lucent_SX5363S_G_723_compliant_codec = 0x1C0C
        case cUseeMe_DigiTalk_exRocwell = 0x1F03
        case nct_Soft_ALF2CD_ACM = 0x1FC4
        case fast_Multimedia_DVM = 0x2000
        case dolby_DTS_Digital_Theater_System = 0x2001
        case realAudio_1and2_14_4 = 0x2002
        case realAudio_1and2_28_8 = 0x2003
        case realAudio_G2and8_Cook_low_bitrate = 0x2004
        case realAudio_3and4and5_Music_DNET = 0x2005
        case realAudio_10_AAC_RAAC = 0x2006
        case realAudio_10_AACplus_RACP = 0x2007
        case reserved_range_to_0x2600_Microsoft = 0x2500
        case makeAVIS = 0x3313
        case divio_MPEG4_AAC_audio = 0x4143
        case nokia_adaptive_multirate = 0x4201
        case divio_G726_Divio_Inc = 0x4243
        case lead_Speech = 0x434C
        case lead_Vorbis = 0x564C
        case wavPack_Audio = 0x5756
        case ogg_Vorbis_mode_1 = 0x674F
        case ogg_Vorbis_mode_2 = 0x6750
        case ogg_Vorbis_mode_3 = 0x6751
        case ogg_Vorbis_mode_1plus = 0x676F
        case ogg_Vorbis_mode_2plus = 0x6770
        case ogg_Vorbis_mode_3plus = 0x6771
        case threeCOM_NBX_3Com_Corporation = 0x7000
        case faad_AAC = 0x706D
        case gsm_AMR_CBR_no_SID = 0x7A21
        case gsm_AMR_VBR_including_SID = 0x7A22
        case comverse_Infosys_Ltd_G723_1 = 0xA100
        case comverse_Infosys_Ltd_AVQSBC = 0xA101
        case comverse_Infosys_Ltd_OLDSBC = 0xA102
        case symbol_Technologies_G729A = 0xA103
        case voiceAge_AMR_WB_VoiceAge_Corporation = 0xA104
        case ingenient_Technologies_Inc_G726 = 0xA105
        case iso_MPEG4_advanced_audio_Coding = 0xA106
        case encore_Software_Ltd_G726 = 0xA107
        case speex_ACM_Codec_xiph_org = 0xA109
        case debugMode_SonicFoundry_Vegas_FrameServer_ACM_Codec = 0xDFAC
        case unknown_59144 = 0xE708
        case free_Lossless_Audio_Codec_FLAC = 0xF1AC
        case extensible = 0xFFFE
        case development = 0xFFFF
    }
}

extension WAVFile.Encoding: Equatable { }

extension WAVFile.Encoding: Hashable { }

extension WAVFile.Encoding: CaseIterable { }

extension WAVFile.Encoding: Sendable { }

extension WAVFile.Encoding: CustomStringConvertible {
    public var description: String {
        name
    }
}

extension WAVFile.Encoding {
    public var name: String {
        switch self {
        case .unknown: "Unknown"
        case .microsoft_PCM: "Microsoft PCM (uncompressed)"
        case .microsoft_ADPCM: "Microsoft ADPCM"
        case .microsoft_IEEE_float: "Microsoft IEEE float"
        case .compaqVSELP: "Compaq VSELP"
        case .iBMCVSD: "IBM CVSD"
        case .iTU_G_711_aLaw: "ITU G.711 a-law"
        case .iTU_G_711_uLaw: "ITU G.711 u-law"
        case .microsoft_DTS: "Microsoft DTS"
        case .drm: "DRM"
        case .wma_9_Speech: "WMA 9 Speech"
        case .microsoft_Windows_Media_RT_Voice: "Microsoft Windows Media RT Voice"
        case .oki_ADPCM: "OKI-ADPCM"
        case .intel_IMA_DVI_ADPCM: "Intel IMA/DVI-ADPCM"
        case .videologic_Mediaspace_ADPCM: "Videologic Mediaspace ADPCM"
        case .sierraADPCM: "Sierra ADPCM"
        case .antex_G_723_ADPCM: "Antex G.723 ADPCM"
        case .dsp_Solutions_DIGISTD: "DSP Solutions DIGISTD"
        case .dsp_Solutions_DIGIFIX: "DSP Solutions DIGIFIX"
        case .dialogic_OKI_ADPCM: "Dialogic OKI ADPCM"
        case .media_Vision_ADPCM: "Media Vision ADPCM"
        case .hp_CU: "HP CU"
        case .hp_Dynamic_Voice: "HP Dynamic Voice"
        case .yamaha_ADPCM: "Yamaha ADPCM"
        case .sonarc_Speech_Compression: "SONARC Speech Compression"
        case .dsp_Group_True_Speech: "DSP Group True Speech"
        case .echo_Speech_Corp: "Echo Speech Corp."
        case .virtual_Music_Audiofile_AF36: "Virtual Music Audiofile AF36"
        case .audio_Processing_Tech: "Audio Processing Tech."
        case .virtual_Music_Audiofile_AF10: "Virtual Music Audiofile AF10"
        case .aculab_Prosody_1612: "Aculab Prosody 1612"
        case .merging_Tech_LRC: "Merging Tech. LRC"
        case .dolby_AC2: "Dolby AC2"
        case .microsoft_GSM610: "Microsoft GSM610"
        case .msn_Audio: "MSN Audio"
        case .antex_ADPCM: "Antex ADPCM"
        case .control_Resources_VQLPC: "Control Resources VQLPC"
        case .dsp_Solutions_DIGIREAL: "DSP Solutions DIGIREAL"
        case .dsp_Solutions_DIGIADPCM: "DSP Solutions DIGIADPCM"
        case .control_Resources_CR10: "Control Resources CR10"
        case .natural_MicroSystems_VBX_ADPCM: "Natural MicroSystems VBX ADPCM"
        case .crystal_Semiconductors_IMA_ADPCM: "Crystal Semiconductors IMA ADPCM"
        case .echo_Speech_ECHOSC3: "Echo Speech ECHOSC3"
        case .rockwell_ADPCM: "Rockwell ADPCM"
        case .rockwell_DIGITALK: "Rockwell DIGITALK"
        case .xebec_Multimedia: "Xebec Multimedia"
        case .antex_G_721_ADPCM: "Antex G.721 ADPCM"
        case .antex_G_728_CELP: "Antex G.728 CELP"
        case .microsoft_MSG723: "Microsoft MSG723"
        case .ibm_AVC_ADPCM: "IBM AVC ADPCM"
        case .itu_T_G_726: "ITU-T G.726"
        case .microsoft_MPEG: "Microsoft MPEG"
        case .rt23_or_PAC: "RT23 or PAC"
        case .inSoft_RT24: "InSoft RT24"
        case .inSoft_PAC: "InSoft PAC"
        case .mp3: "MP3"
        case .cirrus: "Cirrus"
        case .cirrus_Logic: "Cirrus Logic"
        case .ess_Tech_PCM: "ESS Tech. PCM"
        case .voxware_Inc: "Voxware Inc."
        case .canopus_ATRAC: "Canopus ATRAC"
        case .apicom_G_726_ADPCM: "APICOM G.726 ADPCM"
        case .apicom_G_722_ADPCM: "APICOM G.722 ADPCM"
        case .microsoft_DSAT: "Microsoft DSAT"
        case .microsoft_DSAT_DISPLAY: "Microsoft DSAT-DISPLAY"
        case .voxware_Byte_Aligned: "Voxware Byte Aligned"
        case .voxware_ACB: "Voxware ACB"
        case .voxware_AC10: "Voxware AC10"
        case .voxware_AC16: "Voxware AC16"
        case .voxware_AC20: "Voxware AC20"
        case .voxware_MetaVoice: "Voxware MetaVoice"
        case .voxware_MetaSound: "Voxware MetaSound"
        case .voxware_RT29HW: "Voxware RT29HW"
        case .voxware_VR12: "Voxware VR12"
        case .voxware_VR18: "Voxware VR18"
        case .voxware_TQ40: "Voxware TQ40"
        case .voxware_SC3: "Voxware SC3"
        case .voxware_SC3_2: "Voxware SC3"
        case .soundsoft: "Soundsoft"
        case .voxware_TQ60: "Voxware TQ60"
        case .microsoft_MSRT24: "Microsoft MSRT24"
        case .aTandT_G_729A: "AT&T G.729A"
        case .motion_Pixels_MVI_MV12: "Motion Pixels MVI-MV12"
        case .dataFusion_G_726: "DataFusion G.726"
        case .dataFusion_GSM610: "DataFusion GSM610"
        case .iterated_Systems_Audio: "Iterated Systems Audio"
        case .onlive: "Onlive"
        case .multitudeInc_FT_SX20: "Multitude, Inc. FT SX20"
        case .infocom_ITS_AS_G_721_ADPCM: "Infocom IT’S A/S G.721 ADPCM"
        case .convedia_G729: "Convedia G729"
        case .congruencyInc_not_specified: "Congruency, Inc. (not specified)"
        case .siemens_SBC24: "Siemens SBC24"
        case .sonic_Foundry_Dolby_AC3_APDIF: "Sonic Foundry Dolby AC3 APDIF"
        case .mediaSonic_G_723: "MediaSonic G.723"
        case .aculab_Prosody_8kbps: "Aculab Prosody 8kbps"
        case .zyXEL_ADPCM: "ZyXEL ADPCM"
        case .philips_LPCBB: "Philips LPCBB"
        case .studer_Professional_Audio_Packed: "Studer Professional Audio Packed"
        case .maiden_PhonyTalk: "Maiden PhonyTalk"
        case .racal_Recorder_GSM: "Racal Recorder GSM"
        case .racal_Recorder_G720_a: "Racal Recorder G720.a"
        case .racal_G723_1: "Racal G723.1"
        case .racal_Tetra_ACELP: "Racal Tetra ACELP"
        case .nec_AAC_NEC_Corporation: "NEC AAC NEC Corporation"
        case .aac: "AAC"
        case .rhetorex_ADPCM: "Rhetorex ADPCM"
        case .ibm_uLaw: "IBM u-Law"
        case .ibm_aLaw: "IBM a-Law"
        case .ibm_ADPCM: "IBM ADPCM"
        case .vivo_G_723: "Vivo G.723"
        case .vivo_Siren: "Vivo Siren"
        case .philips_Speech_Processing_CELP: "Philips Speech Processing CELP"
        case .philips_Speech_Processing_GRUNDIG: "Philips Speech Processing GRUNDIG"
        case .digital_G_723: "Digital G.723"
        case .sanyo_LD_ADPCM: "Sanyo LD ADPCM"
        case .sipro_Lab_ACEPLNET: "Sipro Lab ACEPLNET"
        case .sipro_Lab_ACELP4800: "Sipro Lab ACELP4800"
        case .sipro_Lab_ACELP8V3: "Sipro Lab ACELP8V3"
        case .sipro_Lab_G_729: "Sipro Lab G.729"
        case .sipro_Lab_G_729A: "Sipro Lab G.729A"
        case .sipro_Lab_Kelvin: "Sipro Lab Kelvin"
        case .voiceAge_AMR: "VoiceAge AMR"
        case .dictaphone_G_726_ADPCM: "Dictaphone G.726 ADPCM"
        case .qualcomm_PureVoice: "Qualcomm PureVoice"
        case .qualcomm_HalfRate: "Qualcomm HalfRate"
        case .ring_Zero_Systems_TUBGSM: "Ring Zero Systems TUBGSM"
        case .microsoft_Audio1: "Microsoft Audio1"
        case .windows_Media_Audio_V2_V7_V8_V9_DivX: "Windows Media Audio V2 V7 V8 V9 / DivX audio (WMA) / Alex AC3 Audio"
        case .windows_Media_Audio_Professional_V9: "Windows Media Audio Professional V9"
        case .windows_Media_Audio_Lossless_V9: "Windows Media Audio Lossless V9"
        case .wMA_Pro_over_SPDIF: "WMA Pro over S/PDIF"
        case .uNISYS_NAP_ADPCM: "UNISYS NAP ADPCM"
        case .uNISYS_NAP_ULAW: "UNISYS NAP ULAW"
        case .uNISYS_NAP_ALAW: "UNISYS NAP ALAW"
        case .uNISYS_NAP_16K: "UNISYS NAP 16K"
        case .mm_SYCOM_ACM_SYC008_SyCom_Technologies: "MM SYCOM ACM SYC008 SyCom Technologies"
        case .mm_SYCOM_ACM_SYC701_G726L_SyCom_Technologies: "MM SYCOM ACM SYC701 G726L SyCom Technologies"
        case .mm_SYCOM_ACM_SYC701_CELP54_SyCom_Technologies: "MM SYCOM ACM SYC701 CELP54 SyCom Technologies"
        case .mm_SYCOM_ACM_SYC701_CELP68_SyCom_Technologies: "MM SYCOM ACM SYC701 CELP68 SyCom Technologies"
        case .knowledge_Adventure_ADPCM: "Knowledge Adventure ADPCM"
        case .fraunhofer_IIS_MPEG2AAC: "Fraunhofer IIS MPEG2AAC"
        case .digital_Theater_Systems_DTS_DS: "Digital Theater Systems DTS DS"
        case .creative_Labs_ADPCM: "Creative Labs ADPCM"
        case .creative_Labs_FASTSPEECH8: "Creative Labs FASTSPEECH8"
        case .creative_Labs_FASTSPEECH10: "Creative Labs FASTSPEECH10"
        case .uher_ADPCM: "UHER ADPCM"
        case .ulead_DV_ACM: "Ulead DV ACM"
        case .ulead_DV_ACM_2: "Ulead DV ACM"
        case .quarterdeck_Corp: "Quarterdeck Corp."
        case .iLink_VC: "I-Link VC"
        case .aureal_Semiconductor_Raw_Sport: "Aureal Semiconductor Raw Sport"
        case .esst_AC3: "ESST AC3"
        case .interactive_Products_HSX: "Interactive Products HSX"
        case .interactive_Products_RPELP: "Interactive Products RPELP"
        case .consistent_CS2: "Consistent CS2"
        case .sony_SCX: "Sony SCX"
        case .sony_SCY: "Sony SCY"
        case .sony_ATRAC3: "Sony ATRAC3"
        case .sony_SPC: "Sony SPC"
        case .telum_Telum_Inc: "TELUM Telum Inc."
        case .telumia_Telum_Inc: "TELUMIA Telum Inc."
        case .norcom_Voice_Systems_ADPCM: "Norcom Voice Systems ADPCM"
        case .fujitsu_FM_TOWNS_SND: "Fujitsu FM TOWNS SND"
        case .fujitsu_not_specified1: "Fujitsu (not specified)"
        case .fujitsu_not_specified2: "Fujitsu (not specified)"
        case .fujitsu_not_specified3: "Fujitsu (not specified)"
        case .fujitsu_not_specified4: "Fujitsu (not specified)"
        case .fujitsu_not_specified5: "Fujitsu (not specified)"
        case .fujitsu_not_specified6: "Fujitsu (not specified)"
        case .fujitsu_not_specified7: "Fujitsu (not specified)"
        case .fujitsu_not_specified8: "Fujitsu (not specified)"
        case .micronas_Semiconductors_Inc_Development: "Micronas Semiconductors, Inc. Development"
        case .micronas_Semiconductors_Inc_CELP833: "Micronas Semiconductors, Inc. CELP833"
        case .brooktree_Digital: "Brooktree Digital"
        case .intel_Music_Coder_IMC: "Intel Music Coder (IMC)"
        case .ligos_Indeo_Audio: "Ligos Indeo Audio"
        case .qDesign_Music: "QDesign Music"
        case .on2_VP7_On2_Technologies: "On2 VP7 On2 Technologies"
        case .on2_VP6_On2_Technologies: "On2 VP6 On2 Technologies"
        case .aTandT_VME_VMPCM: "AT&T VME VMPCM"
        case .aTandT_TCP: "AT&T TCP"
        case .ympeg_Alpha_dummy_for_MPEG2_compressor: "YMPEG Alpha (dummy for MPEG-2 compressor)"
        case .clearJump_LiteWave_lossless: "ClearJump LiteWave (lossless)"
        case .olivetti_GSM: "Olivetti GSM"
        case .olivetti_ADPCM: "Olivetti ADPCM"
        case .olivetti_CELP: "Olivetti CELP"
        case .olivetti_SBC: "Olivetti SBC"
        case .olivetti_OPR: "Olivetti OPR"
        case .lernoutAndHauspie: "Lernout & Hauspie"
        case .lernoutAndHauspie_CELP_codec: "Lernout & Hauspie CELP codec"
        case .lernoutAndHauspie_SBC_codec: "Lernout & Hauspie SBC codec"
        case .lernoutAndHauspie_SBC_codec_2: "Lernout & Hauspie SBC codec"
        case .lernoutAndHauspie_SBC_codec_3: "Lernout & Hauspie SBC codec"
        case .norris_Comm_Inc: "Norris Comm. Inc."
        case .isiAudio: "ISIAudio"
        case .aTandT_Soundspace_Music_Compression: "AT&T Soundspace Music Compression"
        case .voxWare_RT24_speech_codec: "VoxWare RT24 speech codec"
        case .lucent_elemedia_AX24000P_Music_codec: "Lucent elemedia AX24000P Music codec"
        case .sonic_Foundry_LOSSLESS: "Sonic Foundry LOSSLESS"
        case .innings_Telecom_Inc_ADPCM: "Innings Telecom Inc. ADPCM"
        case .lucent_SX8300P_speech_codec: "Lucent SX8300P speech codec"
        case .lucent_SX5363S_G_723_compliant_codec: "Lucent SX5363S G.723 compliant codec"
        case .cUseeMe_DigiTalk_exRocwell: "CUseeMe DigiTalk (ex-Rocwell)"
        case .nct_Soft_ALF2CD_ACM: "NCT Soft ALF2CD ACM"
        case .fast_Multimedia_DVM: "FAST Multimedia DVM"
        case .dolby_DTS_Digital_Theater_System: "Dolby DTS (Digital Theater System)"
        case .realAudio_1and2_14_4: "RealAudio 1 / 2 14.4"
        case .realAudio_1and2_28_8: "RealAudio 1 / 2 28.8"
        case .realAudio_G2and8_Cook_low_bitrate: "RealAudio G2 / 8 Cook (low bitrate)"
        case .realAudio_3and4and5_Music_DNET: "RealAudio 3 / 4 / 5 Music (DNET)"
        case .realAudio_10_AAC_RAAC: "RealAudio 10 AAC (RAAC)"
        case .realAudio_10_AACplus_RACP: "RealAudio 10 AAC+ (RACP)"
        case .reserved_range_to_0x2600_Microsoft: "Reserved range to 0x2600 Microsoft"
        case .makeAVIS: "makeAVIS (ffvfw fake AVI sound from AviSynth scripts)"
        case .divio_MPEG4_AAC_audio: "Divio MPEG-4 AAC audio"
        case .nokia_adaptive_multirate: "Nokia adaptive multirate"
        case .divio_G726_Divio_Inc: "Divio G726 Divio, Inc."
        case .lead_Speech: "LEAD Speech"
        case .lead_Vorbis: "LEAD Vorbis"
        case .wavPack_Audio: "WavPack Audio"
        case .ogg_Vorbis_mode_1: "Ogg Vorbis (mode 1)"
        case .ogg_Vorbis_mode_2: "Ogg Vorbis (mode 2)"
        case .ogg_Vorbis_mode_3: "Ogg Vorbis (mode 3)"
        case .ogg_Vorbis_mode_1plus: "Ogg Vorbis (mode 1+)"
        case .ogg_Vorbis_mode_2plus: "Ogg Vorbis (mode 2+)"
        case .ogg_Vorbis_mode_3plus: "Ogg Vorbis (mode 3+)"
        case .threeCOM_NBX_3Com_Corporation: "3COM NBX 3Com Corporation"
        case .faad_AAC: "FAAD AAC"
        case .gsm_AMR_CBR_no_SID: "GSM-AMR (CBR, no SID)"
        case .gsm_AMR_VBR_including_SID: "GSM-AMR (VBR, including SID)"
        case .comverse_Infosys_Ltd_G723_1: "Comverse Infosys Ltd. G723 1"
        case .comverse_Infosys_Ltd_AVQSBC: "Comverse Infosys Ltd. AVQSBC"
        case .comverse_Infosys_Ltd_OLDSBC: "Comverse Infosys Ltd. OLDSBC"
        case .symbol_Technologies_G729A: "Symbol Technologies G729A"
        case .voiceAge_AMR_WB_VoiceAge_Corporation: "VoiceAge AMR WB VoiceAge Corporation"
        case .ingenient_Technologies_Inc_G726: "Ingenient Technologies Inc. G726"
        case .iso_MPEG4_advanced_audio_Coding: "ISO/MPEG-4 advanced audio Coding"
        case .encore_Software_Ltd_G726: "Encore Software Ltd G726"
        case .speex_ACM_Codec_xiph_org: "Speex ACM Codec xiph.org"
        case .debugMode_SonicFoundry_Vegas_FrameServer_ACM_Codec: "DebugMode SonicFoundry Vegas FrameServer ACM Codec"
        case .unknown_59144: "Unknown"
        case .free_Lossless_Audio_Codec_FLAC: "Free Lossless Audio Codec FLAC"
        case .extensible: "Extensible"
        case .development: "Development"
        }
    }
}
