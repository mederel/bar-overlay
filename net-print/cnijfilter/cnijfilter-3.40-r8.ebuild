# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.40-r8.ebuild,v 1.8 2012/10/26 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0040245.asp"
RESTRICT="mirror"

SRC_URI="http://files.canon-europe.com/files/soft40245/software/${PN}-source-${PV}-1.tar.gz
	scanner? ( http://gdlp01.c-wss.com/gds/3/0100003033/01/scangearmp-source-1.60-1.tar.gz )
"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("mp250" "mp495" "mp280" "mg5100" "mg5200" "ip4800" "mg6100" "mg8100")
ECNIJ_PRID=("356" "369" "370" "373" "374" "375" "376" "377")
IUSE="net scanner symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

if has scanner ${IUSE}; then
	if use scanner; then
		SCANSRC=../scangearmp-source-1.40-1
		ECNIJ_SRC=${SCANSRC}
	fi
	has net ${IUSE} && REQUIRED_USE="scanner? ( net )"
	DEPEND="scanner? ( >=media-gfx/gimp-2.0.0 
		media-gfx/sane-backends
		dev-libs/libusb:0 )"
fi
S="${WORKDIR}"/${PN}-source-${PV}-1

pkg_setup() {
	if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
		[[ -n "$(uname -m | grep 64)" ]] && ARC=64 || ARC=32
	fi
	ecnij_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV/40/20}-4-cups_ppd.patch || die
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/40/20}-4-libpng15.patch || die
	if has scanner ${IUSE} && use scanner; then
		sed -i ${SCANSRC}/scangearmp/backend/Makefile.am \
			-e "s:BACKEND_V_REV):BACKEND_V_REV) -L../../com/libs_bin${ARC}:" || die
		pushd ${SCANSRC} && epatch "${FILESDIR}"/scangearmp-1.70-libpng15.patch && popd
	fi
	ecnij_src_prepare
}

src_install() {
	ecnij_src_install
	local bindir=/usr/bin ldir=/usr/$(get_libdir) gdir p pr prid slot

	if has scanner ${IUSE} && use scanner; then gdir=${ldir}/gimp/2.0/plug-ins
		for p in ${ECNIJ_PRN}; do
			pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
			if use ${pr}; then
				install -m644 ${SCANSRC}/${prid}/*.tbl "${D}${ldir}"/cnijlib || die
				dolib.so ${SCANSRC}/${prid}/libs_bin${ARC}/* || die
			fi
		done
		dolib.so ${SCANSRC}/com/libs_bin${ARC}/* || die
		install -m644 -glp -olp ${SCANSRC}/com/ini/canon_mfp_net.ini "${D}${ldir}"/bjlib || die
		use symlink && dosym {${bindir},${gdir}}/scangearmp || die
		use usb && install -Dm644 \
			{${SCANSRC}/scangearmp,"${D}"}/etc/udev/rules.d/80-canon_mfp.rules || die
	fi
}

pkg_postinst() {
	if use scanner && use usb; then
		if [ -x "$(which udevadm)" ]; then
			einfo ""
			einfo "Reloading usb rules..."
			udevadm control --reload-rules 2> /dev/null
			udevadm trigger --action=add --subsystem-match=usb 2> /dev/null
		else einfo ""
			einfo "Please, reload usb rules manually."
		fi
	fi      
	ecnij_pkg_postinst
}
