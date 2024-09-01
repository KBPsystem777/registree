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
import { useEffect, useState } from "react"

import { Home } from "./pages/Home"
import { useShallow } from "zustand/react/shallow"

function App() {
  const { connected, connect, disconnect } = useConnection()
  const address = useActiveAddress()

  const [walletConnected, setIsWalletConnected] = useState(false)

  let me = window.arweaveWallet.connect()

  console.log("meeee", me)
  const connectionBtn = async () => {
    if (!connected)
      await connect().then(() => {
        console.log("tapos na. konektado ba? ", connected)
        console.log("Address mo: ", address)
        setIsWalletConnected(true)
      })
    console.log("konektdo ba?", connected)
  }

  useEffect(() => {
    connectionBtn()
  }, [me])

  return (
    <ArweaveWalletKit gate>
      {!walletConnected ? (
        <ConnectButton
          accent="rgb(255, 0, 0)"
          profileModal={true}
          showBalance={true}
        />
      ) : (
        <Home />
      )}
    </ArweaveWalletKit>
  )
}

export default App
