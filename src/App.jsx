import {
  result,
  results,
  message,
  spawn,
  monitor,
  unmonitor,
  dryrun,
} from "@permaweb/aoconnect"
import {
  ArweaveWalletKit,
  ConnectButton,
  useActiveAddress,
  useConnection,
} from "arweave-wallet-kit"

import "./App.css"
import { useEffect } from "react"

import { Home } from "./pages/Home"

function App() {
  const { connected, connect, disconnect } = useConnection()
  const address = useActiveAddress()

  let me = window.arweaveWallet.connect()
  console.log(me)
  const connectionBtn = async () => {
    if (!connected)
      await connect().then(() => {
        console.log("tapos na. konektado ba? ", connected)
        console.log("Address mo: ", address)
      })
    console.log("konektdo ba?", connected)
  }

  useEffect(() => {
    connectionBtn()
  }, [connected])

  return (
    <ArweaveWalletKit gate>
      <Home />

      {!me ? (
        <div>connected</div>
      ) : (
        <ConnectButton
          accent="rgb(255, 0, 0)"
          profileModal={true}
          showBalance={true}
        />
      )}

      <p className="read-the-docs">Registree</p>
    </ArweaveWalletKit>
  )
}

export default App
