# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack-audio-connection-kit-1.9999.ebuild,v 1.0 2014/10/10 -tclover Exp $

EAPI=5

inherit flag-o-matic eutils autotools-multilib git-2

RESTRICT="mirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

EGIT_REPO_URI="git://github.com/jackaudio/jack1.git"
EGIT_HAS_SUBMODULES="example-clients"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="3dnow altivec alsa celt coreaudio cpudetection doc debug examples mmx oss sse netjack freebob ieee1394 zalsa"

RDEPEND=">=media-libs/libsndfile-1.0.0[${MULTILIB_USEDEP}]
	sys-libs/ncurses[${MULTILIB_USEDEP}]
	celt? ( >=media-libs/celt-0.5.0[${MULTILIB_USEDEP}] )
	alsa? ( >=media-libs/alsa-lib-0.9.1[${MULTILIB_USEDEP}] )
	freebob? ( sys-libs/libfreebob[${MULTILIB_USEDEP}]
	          !media-libs/libffado[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado[${MULTILIB_USEDEP}]
	           !sys-libs/libfreebob[${MULTILIB_USEDEP}] )
	netjack? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	zalsa? ( media-libs/zita-alsa-pcmi[${MULTILIB_USEDEP}]
		    media-libs/zita-resampler[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	netjack? ( dev-util/scons )"

DOCS=( AUTHORS TODO README )

AUTOTOOLS_AUTORECONF=1

src_prepare()
{
	autotools-multilib_src_prepare
	multilib_copy_sources
}

multilib_src_configure()
{
	local -a myconfargs

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	if use cpudetection && use 3dnow && use mmx && use sse; then
		einfo "Enabling cpudetection (dynsimd)"
		myconfargs=(--enable-dynsimd)
		append-flags -mmmx -msse -m3dnow
	fi

	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	myeconfargs+=(
		$(use_enable ieee1394 firewire)
		$(use_enable freebob)
		$(use_enable altivec)
		$(use_enable alsa)
		$(use_enable coreaudio)
		$(use_enable debug)
		$(use_enable mmx)
		$(use_enable oss)
		$(use_enable sse) 
		$(use_enable zalsa) 
		--disable-dependency-tracking
		--with-default-tmpdir=/dev/shm
		--with-html-dir=/usr/share/doc/${PF}
	)
	ECONF_SOURCE="${BUILD_DIR}" autotools-multilib_src_configure
}

multilib_src_install()
{
	autotools-multilib_src_install
}

multilib_src_install_all()
{
	use examples && dodoc -r example-clients
}
