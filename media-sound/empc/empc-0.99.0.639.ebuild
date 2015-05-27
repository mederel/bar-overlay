# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/empc/empc-0.99.0.639.ebuild,v 1.2 2015/05/26 12:02:10 -tclover Exp $

EAPI=5

PLOCALES="ca eo fr gl it lt pl pt ru sr tr"
case "${PV}" in
	(9999*)
	KEYWORDS=""
	EVCS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"
esac

inherit l10n autotools-utils ${EVCS}

DESCRIPTION="EFL (Enlightenment Foundation Libraries) MPD multiplexer/client"
HOMEPAGE="https://enlightenment.org"

IUSE="glyr +id3tag +nls"
LICENSE="BSD-2"
SLOT="0"

EFL_VERSION=1.12
RDEPEND=">=dev-libs/efl-${EFL_VERSION}
	>=media-libs/elementary-${EFL_VERSION}
	>=media-libs/libmpdclient-2.9
	sys-apps/dbus
	glyr? ( media-libs/glyr )
	id3tag? ( media-libs/libid3tag )"
DEPEND="${RDEPEND}
	virtual/libintl"

DOCS=( AUTHORS README TODO )

src_configure()
{
	local linguas
	use nls && LINGUAS="$(l10n_get_locales)"
	#echo "${linguas}" > po/LINGUAS

	local -a myeconfargs=(
		${EXTRA_EMPC_CONF}
		--disable-mpdule
		$(use_enable glyr module-glyr)
		$(use_enable id3tag module-id3-loader)
	)
	autotools-utils_src_configure
}

pkg_postinst()
{
	elog
	elog "USAGE: Launch empc daemon (empdd <host> <port>); and then empc."
	elog
}