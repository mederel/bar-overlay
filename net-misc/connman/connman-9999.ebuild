# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/connman/connman-9999.ebuild,v 1.6 2014/12/01 20:54:56 -tclover Exp $

EAPI=5

inherit systemd autotools-utils git-2

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="https://01.org/connman/"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/network/connman/connman.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth debug doc examples +ethernet gnutls hardened ofono
openconnect openvpn proxy pptp policykit selinux tools vpnc +wifi"
REQUIRED_USE="selinux? ( openvpn )"

DEPEND=">=sys-kernel/linux-headers-2.6.39
	>=dev-libs/glib-2.18
	>=sys-apps/dbus-1.4
	sys-libs/readline
	>=dev-libs/libnl-1.1
	>=net-firewall/iptables-1.4.11
	gnutls? ( net-libs/gnutls )
	bluetooth? ( net-wireless/bluez )
	ofono? ( net-misc/ofono )
	policykit? ( sys-auth/polkit )
	openconnect? ( net-misc/openconnect[gnutls?] )
	openvpn? ( net-misc/openvpn )
	pacrunner? ( net-misc/pacrunner )
	pptp? ( || ( net-dialup/pptpclient net-dialup/pptpd ) )
	selinux? ( sec-policy/selinux-openvpn )
	vpnc? ( net-misc/vpnc )
	wifi? ( >=net-wireless/wpa_supplicant-0.7[dbus] )"

RDEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure()
{
	local myeconfargs=(
		${EXTRA_CONF}
		--localstatedir=/var
		--enable-client
		--enable-datafiles
		--enable-loopback=builtin
		$(use_enable examples test)
		$(use_enable ethernet ethernet builtin)
		$(use_enable wifi wifi builtin)
		$(use_enable bluetooth bluetooth builtin)
		$(use_enable ofono ofono builtin)
		$(use_enable openconnect openconnect builtin)
		$(use_enable openvpn openvpn builtin)
		$(use_enable policykit polkit builtin)
		$(use_enable selinux)
		$(use_enable proxy pacrunner)
		$(use_enable hardened pie)
		$(use_enable pptp pptp builtin)
		$(use_enable vpnc vpnc builtin)
		$(use_enable debug)
		$(use_enable tools)
		--disable-hh2serial-gps
	)
	autotools-utils_src_configure
}

src_install()
{
	autotools-utils_src_install

	dobin client/connmanctl
	doman doc/connmanctl.1
	use doc && dodoc doc/*.txt

	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit "${FILESDIR}"/connman.service
}

