<template>
  <div class="app">

    <div class="container">

      <div class="column is-8 is-offset-2">
        <div style="margin-top:3%">
          <div class="columns is-vcentered">
            <div class="column">
              <nuxt-link to='/'>
              
              <h1 class="is-size-3" style="margin-left:8px;"> 
                <img src="/favicon.svg" style="width:50px;margin-bottom:-15px"/> &nbsp;
                BlockLeague </h1>
              </nuxt-link>
            </div>


            <div class="column has-text-right" v-if="isLoggedIn">
              <div class="columns is-vcentered">
                <div class="column is-text-right">
                  <jazzicon :address="address" :diameter="30" />
                </div>

                <div class="column">
                <a :href='explorer + address' target="_blank">
                  <h1 class="is-size-4">
                    {{address.substring(0, 12)}} ...
                  </h1>
                </a>
                </div>
              </div>
            </div>

            <div class="column has-text-right" v-else>
              <b-button class="button is-info is-outlined" style="width:40%"> Login </b-button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- <nav
      class="navbar header has-shadow is-primary"
      role="navigation"
      aria-label="main navigation"
    >
      <div class="navbar-brand">
        <a
          class="navbar-item"
          href="/"
        >
          <img
            src="~assets/buefy.png"
            alt="Buefy"
            height="28"
          >
        </a>

        <div class="navbar-burger">
          <span />
          <span />
          <span />
        </div>
      </div>
    </nav> -->

    <!-- <section class="main-content columns">
      <aside class="column is-2 section">
        <p class="menu-label is-hidden-touch">
          General
        </p>
        <ul class="menu-list">
          <li
            v-for="(item, key) of items"
            :key="key"
          >
            <nuxt-link
              :to="item.to"
              exact-active-class="is-active"
            >
              <b-icon :icon="item.icon" /> {{ item.title }}
            </nuxt-link>
          </li>
        </ul>
      </aside> -->

    <div class="container">
      <nuxt />
    </div>

    <footer class="has-text-centered">
      <h1 style="padding-bottom:2em">
        Made with <img src="https://image.flaticon.com/icons/svg/148/148838.svg"
          style="width:20px;margin-bottom:-4px;" /> by Team <a href='https://en.wikipedia.org/wiki/Panchajanya'
          target='_blank'>Panchajanya</a>.
      </h1>
    </footer>
  </div>
</template>

<script>
  import Jazzicon from 'vue-jazzicon';

  export default {

    components: {
      Jazzicon
    },
    data() {
      return {
        isLoggedIn: false,
        address: '',
        explorer: 'https://explorer.testnet2.matic.network/address/'
      }
    },

    methods: {
      async connectMetamask() {
        if (window.ethereum) {
          window.web3 = new Web3(ethereum);
          this.isLoggedIn = true
          this.address = web3.currentProvider.selectedAddress
          try {
            await ethereum.enable();
          } catch (error) {
            console.log(error)
          }
        } else if (window.web3) {
          window.web3 = new Web3(web3.currentProvider);
        } else {
          alert('Please use Web3 Enabled Device')
        }
      },
    },

    created() {
      this.connectMetamask()
    }
  }

</script>


<style lang="scss" scoped>


  @font-face {
    font-family: 'CircularStd';
    src: url('~assets/CircularStd-Book.woff') format('woff2'),
  }



  .app {
    font-family: CircularStd, sans-serif;
    letter-spacing: 0.5px;
    font-display: swap;
    background: rgb(244, 245, 246);

  }

</style>
