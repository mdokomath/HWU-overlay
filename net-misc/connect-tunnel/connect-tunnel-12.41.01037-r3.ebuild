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

pkg_postinst() {
  einfo "As a regular user, run"
  einfo "  hwu-vpn"
  einfo "in a trminal. In the window that opens, select \"add configuration\""
  einfo "from the \"Configuration\" drop down menu. The server to which you"
  einfo "need to connect is"
  einfo "  hwvpn.hw.ac.uk"
  einfo "Save the configuration an click connect. Finally select \"HWAzure\""
  einfo "as the login group. You will now be sent to the login portal, where"
  einfo "you will need your 2FA credentials."
  einfo "The configuration needs to be entered only the first time; subsequent"
  einfo "uses of the client will send you directly to the login page after"
  einfo "clicking connect."
  einfo "To disconnect shut down the client via the system tray icon."

  ewarn "The kernel needs to be configured with CONFIG_TUN=y or CONFIG_TUN=m."
  ewarn "With CONFIG_TUN=n, the client hangs when attempting to connect."
}
