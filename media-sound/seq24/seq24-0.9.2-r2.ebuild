# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/seq24/seq24-0.9.2-r1.ebuild,v 1.5 2014/07/20 17:54:33 -tclover Exp $

EAPI="5"

inherit eutils

DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="https://edge.launchpad.net/seq24/"
SRC_URI="https://edge.launchpad.net/seq24/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="jack lash"

RDEPEND="media-libs/alsa-lib
	>=dev-cpp/gtkmm-2.4:2.4
	>=dev-libs/libsigc++-2.2:2
	jack? ( >=media-sound/jack-audio-connection-kit-0.90 )
	lash? ( virtual/liblash )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README RTC SEQ24 )

src_prepare() {
	epatch "${FILESDIR}"/${P}-lash-fix.patch
	epatch "${FILESDIR}"/${P}-jacksession-fix.patch
}

src_configure() {
	econf \
		$(use_enable jack) \
		$(use_enable lash)
}

src_install() {
	default
	newicon src/pixmaps/seq24_32.xpm seq24.xpm
	make_desktop_entry seq24
}
