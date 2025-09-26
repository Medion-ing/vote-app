import React, { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

const API_URL = 'http://192.168.1.177:8000'

function App() {
  const [formData, setFormData] = useState({
    firstname: '',
    lastname: '',
    gender: '',
    vote: ''
  })
  const [message, setMessage] = useState('')
  const [results, setResults] = useState([])
  const [lastUpdate, setLastUpdate] = useState('')

  useEffect(() => {
    console.log('🔵 Initialisation du composant')
    fetchResults()
    
    // Polling toutes les 2 secondes pour les résultats en temps réel
    const interval = setInterval(() => {
      fetchResults()
    }, 2000)
    
    return () => clearInterval(interval)
  }, [])

  const fetchResults = async () => {
    try {
      const response = await axios.get(`${API_URL}/results`)
      setResults(response.data)
      setLastUpdate(new Date().toLocaleTimeString())
    } catch (error) {
      console.error('❌ Erreur récupération résultats:', error)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    // Validation côté client
    if (!formData.gender) {
      setMessage('❌ Veuillez sélectionner une civilité')
      return
    }
  
    if (!formData.firstname || !formData.lastname || !formData.vote) {
      setMessage('❌ Tous les champs sont obligatoires')
      return
    }

    try {
      const response = await axios.post(`${API_URL}/vote`, formData)
      setMessage(response.data.message)
      setFormData({ firstname: '', lastname: '', gender: '', vote: '' })
      
      // Rafraîchir les résultats immédiatement après un vote
      setTimeout(() => {
        fetchResults()
      }, 500)
      
    } catch (error) {
      setMessage(error.response?.data?.detail || 'Erreur lors du vote')
    }
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const totalVotes = results.reduce((sum, item) => sum + item.votes, 0)

  return (
    <div className="app">
      <header>
        <h1>🗳️ Système de Vote en Temps Réel</h1>
        <p>Total des votes: {totalVotes} | Dernière mise à jour: {lastUpdate}</p>
      </header>

      <div className="container">
        <div className="vote-section">
          <h2>Votez maintenant !</h2>
          <form onSubmit={handleSubmit} className="vote-form">
            <input
              type="text"
              name="firstname"
              placeholder="Prénom"
              value={formData.firstname}
              onChange={handleChange}
              required
            />
            
            <input
              type="text"
              name="lastname"
              placeholder="Nom"
              value={formData.lastname}
              onChange={handleChange}
              required
            />
            
            <select 
              name="gender" 
              value={formData.gender}
              onChange={handleChange}
              required
            >
              <option value="">Civilité</option>
              <option value="M">M.</option>
              <option value="F">Mme</option>
            </select>

            <div className="vote-options">
              <strong>Votre langage préféré :</strong>
              {['Python', 'JavaScript', 'Go', 'C', 'Java', 'Rust'].map(lang => (
                <label key={lang} className="option">
                  <input
                    type="radio"
                    name="vote"
                    value={lang}
                    checked={formData.vote === lang}
                    onChange={handleChange}
                    required
                  />
                  {lang}
                </label>
              ))}
            </div>
            
            <button type="submit" className="vote-button">
              Voter ✓
            </button>
          </form>
          
          {message && (
            <div className={`message ${message.includes('Erreur') ? 'error' : 'success'}`}>
              {message}
            </div>
          )}
        </div>

        <div className="results-section">
          <h2>Résultats en direct</h2>
          <div className="results">
            {results.length > 0 ? (
              results.map((item, index) => (
                <div key={index} className="result-item">
                  <span className="language">{item.choice}</span>
                  <div className="bar-container">
                    <div 
                      className="bar" 
                      style={{ 
                        width: `${totalVotes > 0 ? (item.votes / totalVotes) * 100 : 0}%` 
                      }}
                    ></div>
                  </div>
                  <span className="votes">{item.votes} votes</span>
                </div>
              ))
            ) : (
              <p>Aucun vote pour le moment</p>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

export default App