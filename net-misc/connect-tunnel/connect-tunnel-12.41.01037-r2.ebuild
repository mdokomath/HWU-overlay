# Copyright 2023 Marko Doko <m.doko@hw.ac.uk>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ConnectTunnel"
MY_A="${MY_PN}-Linux64-${PV}.tar.bz2"

DESCRIPTION="The client for connecting to the VPN of Heriot-Watt University"
HOMEPAGE="https://www.hw.ac.uk/uk/services/is/it-essentials/virtual-private-network-vpn.htm"
SRC_URI="https://www.hw.ac.uk/uk/services/docs/is/${MY_PN}_Linux64.tar"

S="${WORKDIR}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="virtual/jre"
DEPEND="${RDEPEND}"
BDEPEND=""

PATCHES=(
  "${FILESDIR}/installation_directory.patch"
)


src_unpack() {
  unpack ${A}
  if [ -f ${MY_A} ]
  then
    tar xf ${MY_A}
  else
    die "Ebuild version incorrect."
  fi
}

src_configure() {
  true
}

src_compile() {
  true
}

src_test() {
  true
}

src_install() {
  dodir "/usr/local/Aventail"
  rm "${S}"/usr/local/Aventail/{certs.tar.bz2,uninstall.sh} || die
  if ! use doc
  then
    rm -r "${S}"/usr/local/Aventail/help || die
  fi
  cp -R "${S}/usr" ${D}
  chmod ugo+x ${D}/usr/local/Aventail/{AvConnect,startct.sh,startctui.sh} || die
  chmod 4755 ${D}/usr/local/Aventail/AvConnect || die
  dosym "/usr/local/Aventail/startct.sh" "/usr/bin/startct"
  dosym "/usr/local/Aventail/startctui.sh" "/usr/bin/startctui"
  dosym "/usr/local/Aventail/startctui.sh" "/usr/bin/hwu-vpn"
  dosym "/etc/ssl/certs" "/opt/hwu-vpn/certs"
}

