import firebase from "@/plugins/firebase";

export const state = () => ({
  user: {
    uid: '',
    name: '',
    email: '',
    login: false
  }
})

export const getters = {
  user: state => {
    return state.user
  }
}

export const actions = {
  // login ({ commit }, payload) {
  //   firebase.auth().signInWithEmailAndPassword(payload.email, payload.password)
  //   .then(user => {
  //     console.log('success');
  //     firebase.auth().onAuthStateChanged(function (user) {
  //       if (user) {
  //         commit('getData', {
  //           uid: user.id,
  //           email: user.email
  //         })
  //         commit('switchLogin')
  //       }
  //     })
  //   })
  // },
  async login ({ commit }, payload) {
    const loginUser = await this.$axios.$post('/api/v1/sessions', {
      session: {
        email: payload.email,
        password: payload.password,
      }
    })
    console.log(loginUser.status);
    console.log(loginUser.data.name);
    console.log(loginUser.data.email);
    await commit('getData', {
      uid: loginUser.data.id,
      name: loginUser.data.name,
      email: loginUser.data.email,
    })
    await commit('switchLogin')
    alert(loginUser.data.name)
    // this.$router.push({ path: `/users/ + ${loginUser.data.id}` })
    this.$router.push({ path: `/users/${loginUser.data.id}` })
  }
}

export const mutations = {
  getData (state, payload) {
    state.user.uid = payload.uid
    state.user.name = payload.name
    state.user.email = payload.email
  },
  switchLogin (state) {
    state.user.login = true
  }
}
