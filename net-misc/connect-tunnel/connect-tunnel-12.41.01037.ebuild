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
  dodir "/opt/hwu-vpn"

  location="${S}/usr/local/Aventail"

  cp "${location}/AvConnect" "${D}/opt/hwu-vpn" || die
  cp "${location}/certs.tar.bz2" "${D}/opt/hwu-vpn" || die
  cp "${location}/logo.png" "${D}/opt/hwu-vpn" || die
  cp -R "${location}/man" "${D}/opt/hwu-vpn" || die
  cp -R "${location}/nui" "${D}/opt/hwu-vpn"  || die
  cp "${location}/startct.sh" "${D}/opt/hwu-vpn" || die
  cp "${location}/startctui.sh" "${D}/opt/hwu-vpn" || die
  dosym "/opt/hwu-vpn/startct.sh" "/opt/bin/startct"
  dosym "/opt/hwu-vpn/startctui.sh" "/opt/bin/startctui"

  if use doc
  then
    cp -R "${location}/help" "${D}/opt/hwu-vpn" || die
  fi

  chmod ugo+x ${D}/opt/hwu-vpn/{AvConnect,startct.sh,startctui.sh} || die
  chmod 4755 ${D}/opt/hwu-vpn/AvConnect || die

  dosym "/etc/ssl/certs" "/opt/hwu-vpn/certs"
}

