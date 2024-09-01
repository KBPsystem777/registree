import React from "react"

const LoadingModal = ({ isVisible }) => {
  if (!isVisible) return null

  return (
    <div className="loading-modal-overlay">
      <div className="loading-modal-content">
        <div className="loader"></div>
        <p>Loading...</p>
      </div>
    </div>
  )
}

export default LoadingModal
