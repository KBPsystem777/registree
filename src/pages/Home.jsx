import { useState } from "react"
import farms from "./data/farms.json"
import LoadingModal from "../components/LoadingModal"

export const Home = () => {
  const [isModalVisible, setIsModalVisible] = useState(false)

  const handleButtonClick = () => {
    setIsModalVisible(true)
    setTimeout(() => {
      setIsModalVisible(false)
    }, 4000) // Hide the modal after 2 seconds
  }

  const imgSrc = "https://i.ibb.co/d0tWxdf/Screenshot-2024-08-29-204940.png"
  return (
    <div>
      <h1>Registree Marketplace</h1>
      <div>
        {farms.data.map((data) => (
          <div>
            <div className="card">
              <h2>Aquilaria malaccensis</h2>
              <img src={imgSrc} className="card-image"></img>
              <p className="farmLocation">{data.location}</p>
              <div className="farmContent">
                <p>Current share price: PHP 2000</p>
                <p>Available shares: {`${data?.availableShares}/500`}</p>
                <p>ID: {data?.id}</p>
              </div>
              <div>
                <button onClick={handleButtonClick}>Invest</button>
              </div>
            </div>
          </div>
        ))}
      </div>
      <LoadingModal isVisible={isModalVisible} />
    </div>
  )
}
