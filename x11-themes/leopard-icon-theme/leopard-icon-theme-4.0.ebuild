# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/leopard-icon-theme-4.0.ebuild,v 1.0 2012/05/05 -tclover Exp $

inherit gnome2-utils

DESCRIPTION="A very good lepard gtk port theme"
HOMEPAGE="http://badimnk.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/274872640/gnome_leopard_icons_by_badimnk-d4jnh34.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="theme minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )
	theme? ( x11-themes/${PN/icon/gtk} )
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/icons
	doins -r leoicons || die
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() {
	gnome2_icon_cache_update
	einfo
	einfo "one should run the scripts to delete previous profile to create a"
	einfo "new one or colorize the icon set"
	einfo
}
pkg_postrm() { gnome2_icon_cache_update; }
