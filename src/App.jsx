import { useEffect, useState } from "react"

import {
  ArweaveWalletKit,
  ConnectButton,
  useConnection,
} from "arweave-wallet-kit"

import { Home } from "./pages/Home"

import "./App.css"

function App() {
  const { connected, connect } = useConnection()

  const [walletConnected, setIsWalletConnected] = useState(false)

  let arWallet = window.arweaveWallet.connect()

  const connectionBtn = async () => {
    if (!connected)
      await connect().then(() => {
        setIsWalletConnected(true)
      })
  }

  useEffect(() => {
    connectionBtn()
  }, [arWallet])

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
