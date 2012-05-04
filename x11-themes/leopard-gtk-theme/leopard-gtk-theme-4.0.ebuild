# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/leopard-gtk-theme-4.0.ebuild,v 1.0 2012/05/05 -tclover Exp $

inherit eutils

DESCRIPTION="A very good lepard gtk port theme"
HOMEPAGE="http://badimnk.deviantart.com/"
SRC_URI="http://gnome-look.org/CONTENT/content-files/147309-gnome-leopard.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="icon minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
	x11-themes/gtk-engines-murrine
	icon? ( x11-thems/${PN/gtk/icon} )
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	unpack ./gnome-leopard/leopard.tar.gz || die
}

src_install() {
	insinto /usr/share/themes
	doins -r leopard || die
}
