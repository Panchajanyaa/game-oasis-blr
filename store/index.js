export const state = () => ({
    isLoggedIn: ''
  })
  
  export const mutations = {
    updateLoginState(state, status) {
      state.isLoggedIn = status
    }
  }
  