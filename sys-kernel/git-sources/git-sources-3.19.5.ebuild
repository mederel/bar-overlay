# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.19.5.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfq bfs ck fbcondecor gentoo hardened optimization reiser4)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

BFS_VER="461"
CK_VER="${MKV}-ck1"
CK_SRC="${CK_VER}-broken-out.tar.xz"
GENTOO_VER="${MKV}-${KV_PATCH}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${OKV}-2"
REISER4_VER="${OKV}"

inherit kernel-git
