# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-scrawl/vapoursynth-plugins-scrawl-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dubhater/${PN/-plugins}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dubhater/${PN/-plugins}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Text output plugin for VapourSynth"
HOMEPAGE="https://github.com/dubhater/vapoursynth-scrawl"

LICENSE="LGPL-2.1 OFL-1.1"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:="
DEPEND="${RDEPEND}
	media-fonts/terminus-font"

DOCS=( readme.rst )
AUTOTOOLS_AUTORECONF=1
S="${WORKDIR}/${PN/-plugins}-${PV}"

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_FFMS_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
