#!/bin/sh
# Copyright (c) 2014 John Ko

RELEASE=10.0-RELEASE
#RELEASE=`uname -r`
ARCH=amd64
#ARCH=`uname -m`

if [ ! -e /usr/local/bin/gpg2 ]; then
	/usr/local/sbin/pkg-static install -y gnupg \
	> /dev/null 2> /dev/null
fi

if [ "$1" = "nox" ]; then
	NOX=1
fi
if [ "${NOX}" = "1" ]; then
	IMAGE_PREFIX=NOX
else
	IMAGE_PREFIX=PERSONAL
fi
if [ ! -d /cdrom ]; then
	/bin/mkdir -p /cdrom >/dev/null 2>&1
fi
if [ ! -d /cdrom/usr/freebsd-dist ]; then
	echo Please mount a FreeBSD iso at /cdrom
	exit 1
fi
/usr/bin/find tmp -type l -exec /bin/chflags -h nosunlink {} \;
/bin/rm tmp/.install* tmp/.boot_done tmp/.co* tmp/.extract_done tmp/.fbsddist_done tmp/.mfsroot_done tmp/.p* tmp/.gen* tmp/.gpg* tmp/.enc*
/bin/rm -r tmp/dist
/bin/rm -r tmp/disk
/bin/rm -r tmp/mfs
/bin/rm ${IMAGE_PREFIX}*.iso
/bin/rm ${IMAGE_PREFIX}*.img
/bin/rm ${IMAGE_PREFIX}*.tar

if [ ! -e tools/pkg-static ]; then
	/bin/cp -a `which pkg-static` tools/pkg-static || exit 1
fi

#/bin/ls -1 /boot/kernel/ | /usr/bin/sed 's#.ko$##' | /usr/bin/sort -u | /usr/bin/tr '\n' ' '
MFSMODULES="aac aacraid accf_data accf_dns accf_http acl_nfs4 acl_posix1e acpi_asus acpi_asus_wmi acpi_dock acpi_fujitsu acpi_hp acpi_ibm acpi_panasonic acpi_sony acpi_toshiba acpi_video acpi_wmi aesni agp aha ahc ahc_eisa ahc_isa ahc_pci ahci ahd aibs aio alias_cuseeme alias_dummy alias_ftp alias_irc alias_nbt alias_pptp alias_skinny alias_smedia alpm alq amdpm amdsbwd amdsmb amdtemp amr amr_cam amr_linux aout arcmsr asmc ata ataacard ataacerlabs ataadaptec ataahci ataamd ataati atacard atacenatek atacypress atacyrix atahighpoint ataintel ataisa ataite atajmicron atamarvell atamicron atanational atanetcell atanvidia atapci atapromise ataserverworks atasiliconimage atasis atavia atp beastie_saver bktr bktr_mem blank_saver bridgestp cam cardbus carp cbb cc_cdg cc_chd cc_cubic cc_hd cc_htcp cc_vegas cd9660 cd9660_iconv ciss cmx coretemp cpuctl cpufreq crypto cryptodev ctl cxgb_t3fw cyclic daemon_saver dcons dcons_crom dpms dragon_saver drm drm2 dtio dtmalloc dtnfscl dtnfsclient dtrace dtrace_test dtraceall dummynet ehci esp exca ext2fs fade_saver fasttrap fbt fdc fdescfs filemon fire_saver firewire firmware fuse geom_bde geom_bsd geom_cache geom_ccd geom_concat geom_eli geom_fox geom_gate geom_journal geom_label geom_linux_lvm geom_mbr geom_md geom_mirror geom_mountver geom_multipath geom_nop geom_part_apm geom_part_bsd geom_part_ebr geom_part_gpt geom_part_ldm geom_part_mbr geom_part_pc98 geom_part_vtoc8 geom_pc98 geom_raid geom_raid3 geom_sched geom_shsec geom_stripe geom_sunlabel geom_uzip geom_vinum geom_virstor geom_vol_ffs geom_zero green_saver gsched_rr h_ertt hifn hpt27xx hptiop hptmv hptnr hptrr hv_ata_pci_disengage hv_netvsc hv_storvsc hv_utils hv_vmbus hwpmc i915 i915kms ichsmb ichwd ida if_ae if_age if_alc if_ale if_an if_ath if_ath_pci if_aue if_axe if_bce if_bfe if_bge if_bridge if_bwi if_bwn if_bxe if_cas if_cdce if_cue if_cxgb if_cxgbe if_dc if_de if_disc if_ed if_edsc if_ef if_em if_en if_epair if_et if_faith if_fatm if_fwe if_fwip if_fxp if_gem if_gif if_gre if_hatm if_hme if_ic if_igb if_ipheth if_ipw if_iwi if_iwn if_ixgb if_ixgbe if_jme if_kue if_lagg if_le if_lge if_lmc if_malo if_mos if_msk if_mwl if_mxge if_my if_ndis if_nfe if_nge if_ntb if_nve if_nxge if_patm if_pcn if_qlxgb if_qlxgbe if_qlxge if_ral if_re if_rl if_rsu if_rue if_rum if_run if_sf if_sge if_sis if_sk if_smsc if_sn if_ste if_stf if_stge if_tap if_ti if_tl if_tun if_tx if_txp if_uath if_udav if_upgt if_ural if_urtw if_urtwn if_vge if_vlan if_vmx if_vr if_vte if_vtnet if_vx if_wb if_wi if_wpi if_xl if_zyd iic iicbb iicbus iicsmb iir intpm io ip6_mroute ip_mroute ipdivert ipfw ipfw_nat ipmi ipmi_linux ips ipw_bss ipw_ibss ipw_monitor isci iscsi iscsi_initiator isp isp_1040 isp_1040_it isp_1080 isp_1080_it isp_12160 isp_12160_it isp_2100 isp_2200 isp_2300 isp_2322 isp_2400 isp_2400_multi isp_2500 isp_2500_multi ispfw iw_cxgb iw_cxgbe iwi_bss iwi_ibss iwi_monitor iwn1000fw iwn2030fw iwn4965fw iwn5000fw iwn5150fw iwn6000fw iwn6000g2afw iwn6000g2bfw iwn6050fw joy kbdmux kernel kgssapi kgssapi_krb5 krpc krping ksyms libalias libiconv libmbpool libmchain lindev linker.hints linprocfs linsysfs linux lockstat logo_saver lpbb lpt mac_biba mac_bsdextended mac_ifoff mac_lomac mac_mls mac_none mac_partition mac_portacl mac_seeotheruids mac_stub mac_test mach64 mcd mem mfi mfi_linux mfip mga miibus mlx mly mmc mmcsd mps mpt mqueuefs msdosfs msdosfs_iconv mvs mw88W8363fw mxge_eth_z8e mxge_ethp_z8e mxge_rss_eth_z8e mxge_rss_ethp_z8e ndis netgraph nfs_common nfscl nfsclient nfscommon nfsd nfslock nfslockd nfsmb nfsserver nfssvc ng_UI ng_async ng_atm ng_atmllc ng_bpf ng_bridge ng_car ng_ccatm ng_cisco ng_deflate ng_device ng_echo ng_eiface ng_etf ng_ether ng_ether_echo ng_fec ng_frame_relay ng_gif ng_gif_demux ng_hole ng_hub ng_iface ng_ip_input ng_ipfw ng_ksocket ng_l2tp ng_lmi ng_mppc ng_nat ng_netflow ng_one2many ng_patch ng_pipe ng_ppp ng_pppoe ng_pptpgre ng_pred1 ng_rfc1490 ng_socket ng_source ng_split ng_sppp ng_sscfu ng_sscop ng_tag ng_tcpmss ng_tee ng_tty ng_uni ng_vjc ng_vlan ngatmbase nmdm ntb_hw nullfs nvd nvme nvram oce ohci opensolaris padlock pccard pcf pf pflog pfsync plip ppbus ppc ppi pps procfs profile prototype pseudofs pty puc r128 radeon radeonkms radeonkmsfw_ARUBA_me radeonkmsfw_ARUBA_pfp radeonkmsfw_ARUBA_rlc radeonkmsfw_BARTS_mc radeonkmsfw_BARTS_me radeonkmsfw_BARTS_pfp radeonkmsfw_BTC_rlc radeonkmsfw_CAICOS_mc radeonkmsfw_CAICOS_me radeonkmsfw_CAICOS_pfp radeonkmsfw_CAYMAN_mc radeonkmsfw_CAYMAN_me radeonkmsfw_CAYMAN_pfp radeonkmsfw_CAYMAN_rlc radeonkmsfw_CEDAR_me radeonkmsfw_CEDAR_pfp radeonkmsfw_CEDAR_rlc radeonkmsfw_CYPRESS_me radeonkmsfw_CYPRESS_pfp radeonkmsfw_CYPRESS_rlc radeonkmsfw_JUNIPER_me radeonkmsfw_JUNIPER_pfp radeonkmsfw_JUNIPER_rlc radeonkmsfw_PALM_me radeonkmsfw_PALM_pfp radeonkmsfw_PITCAIRN_ce radeonkmsfw_PITCAIRN_mc radeonkmsfw_PITCAIRN_me radeonkmsfw_PITCAIRN_pfp radeonkmsfw_PITCAIRN_rlc radeonkmsfw_R100_cp radeonkmsfw_R200_cp radeonkmsfw_R300_cp radeonkmsfw_R420_cp radeonkmsfw_R520_cp radeonkmsfw_R600_me radeonkmsfw_R600_pfp radeonkmsfw_R600_rlc radeonkmsfw_R700_rlc radeonkmsfw_REDWOOD_me radeonkmsfw_REDWOOD_pfp radeonkmsfw_REDWOOD_rlc radeonkmsfw_RS600_cp radeonkmsfw_RS690_cp radeonkmsfw_RS780_me radeonkmsfw_RS780_pfp radeonkmsfw_RV610_me radeonkmsfw_RV610_pfp radeonkmsfw_RV620_me radeonkmsfw_RV620_pfp radeonkmsfw_RV630_me radeonkmsfw_RV630_pfp radeonkmsfw_RV635_me radeonkmsfw_RV635_pfp radeonkmsfw_RV670_me radeonkmsfw_RV670_pfp radeonkmsfw_RV710_me radeonkmsfw_RV710_pfp radeonkmsfw_RV730_me radeonkmsfw_RV730_pfp radeonkmsfw_RV770_me radeonkmsfw_RV770_pfp radeonkmsfw_SUMO2_me radeonkmsfw_SUMO2_pfp radeonkmsfw_SUMO_me radeonkmsfw_SUMO_pfp radeonkmsfw_SUMO_rlc radeonkmsfw_TAHITI_ce radeonkmsfw_TAHITI_mc radeonkmsfw_TAHITI_me radeonkmsfw_TAHITI_pfp radeonkmsfw_TAHITI_rlc radeonkmsfw_TURKS_mc radeonkmsfw_TURKS_me radeonkmsfw_TURKS_pfp radeonkmsfw_VERDE_ce radeonkmsfw_VERDE_mc radeonkmsfw_VERDE_me radeonkmsfw_VERDE_pfp radeonkmsfw_VERDE_rlc rain_saver random rc4 reiserfs rsu-rtl8712fw rt2561fw rt2561sfw rt2661fw rt2860fw runfw s3 safe savage sbp sbp_targ scc scd scsi_low sdhci sdhci_pci sdt sem send sfxge siba_bwn siftr siis sis smb smbfs smbus snake_saver snd_ad1816 snd_als4000 snd_atiixp snd_cmi snd_cs4281 snd_csa snd_driver snd_ds1 snd_emu10k1 snd_emu10kx snd_envy24 snd_envy24ht snd_es137x snd_ess snd_fm801 snd_hda snd_hdspe snd_ich snd_maestro snd_maestro3 snd_mss snd_neomagic snd_sb16 snd_sb8 snd_sbc snd_solo snd_spicds snd_t4dwave snd_uaudio snd_via8233 snd_via82c686 snd_vibes snp sound speaker splash_bmp splash_pcx splash_txt sppp star_saver sym systrace systrace_freebsd32 systrace_linux32 sysvmsg sysvsem sysvshm t3_tom t4_tom t4fw_cfg t5fw_cfg tdfx tmpfs toecore tpm trm twa twe tws u3g uark uart ubsa ubsec ubser uchcom ucom ucycom udbp udf udf_iconv uep uether ufm ufoma ufs uftdi ugensa uhci uhid uhso uipaq ukbd ulpt umass umcs umct umodem umoscom ums unionfs uplcom urio urtwn-rtl8192cfwT urtwn-rtl8192cfwU usb usb_quirk usb_template usfs usie uslcom utopia uvisor uvscom vesa via viapm viawd virtio virtio_balloon virtio_blk virtio_pci virtio_scsi vkbd vmm vpo vxge warp_saver wbwd wlan wlan_acl wlan_amrr wlan_ccmp wlan_rssadapt wlan_tkip wlan_wep wlan_xauth wpifw x86bios xhci zfs zlib"
if [ "x" = "x${MFSMODULES}" ]; then
	MFSMODULES="$4"
fi

if [ "$2" = "imgtar" -o "$2" = "all" ]; then
	/usr/bin/make enctar \
		RELEASE=${RELEASE}  ARCH=${ARCH} \
		IMAGE_PREFIX=${IMAGE_PREFIX} \
		MFSMODULES="$MFSMODULES" \
		MFSROOT_MAXSIZE=999m \
		KEYCFG="mfsbsdonly all $3" \
		PKGNG=1 \
		SE=1 || exit 1
fi
if [ "$2" = "iso" -o "$2" = "all" ]; then
	/usr/bin/make enciso \
		RELEASE=${RELEASE}  ARCH=${ARCH} \
		IMAGE_PREFIX=${IMAGE_PREFIX} \
		MFSMODULES="$MFSMODULES" \
		MFSROOT_MAXSIZE=999m \
		KEYCFG="mfsbsdonly all $3" \
		PKGNG=1 \
		SE=1 || exit 1
fi
if [ "$2" = "imgtar" -o "$2" = "all" ]; then
	if /sbin/sysctl security.jail.jailed | /usr/bin/grep 0 >/dev/null 2>&1 ; then
		DOFSSIZE=$(( `ls -l ${IMAGE_PREFIX}-${RELEASE}-${ARCH}.iso | awk '{print $5}'` / 1000 ))
		if [ -n "${DOFSSIZE}" ]; then
		/usr/bin/make encimage \
			RELEASE=${RELEASE}  ARCH=${ARCH} \
			IMAGE_PREFIX=${IMAGE_PREFIX} \
			MFSMODULES="$MFSMODULES" \
			MFSROOT_MAXSIZE=999m \
			DOFSSIZE=${DOFSSIZE} \
			KEYCFG="mfsbsdonly all $3" \
			PKGNG=1 \
			SE=1 || exit 1
		fi
	fi
fi
/bin/chmod 644 ${IMAGE_PREFIX}*.iso
/bin/chmod 644 ${IMAGE_PREFIX}*.img
/bin/chmod 644 ${IMAGE_PREFIX}*.tar
