# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4

EAPI=8

CRATES=" "
inherit cargo

DESCRIPTION="Open source Virtual Machine Monitor (VMM) that runs on top of KVM"
HOMEPAGE="https://www.cloudhypervisor.org"
SRC_URI="https://github.com/cloud-hypervisor/cloud-hypervisor/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~jsmolic/distfiles/${P}-vendor.tar.gz"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	cargo_src_unpack
	mkdir  "${S}"/{vendor,.cargo} || die
	ln -s "${WORKDIR}/vendor/"* "${S}"/vendor || die
	cp "${FILESDIR}"/${P}-vendor-config "${S}"/.cargo/config.toml || die
}

src_prepare() {
	default
	sed -i 's/strip = true/strip = false/' Cargo.toml || die
}

src_configure() {
	cargo_gen_config
	cargo_src_configure --frozen
}

src_test() {
	# Intergration tests require root
	# https://github.com/cloud-hypervisor/cloud-hypervisor/issues/5388
	cargo_src_test --bins
}

src_install() {
	cargo_src_install
	dodoc -r docs
}
