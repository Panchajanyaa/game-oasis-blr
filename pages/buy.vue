<template>
  <section class="section">
    <div class="columns is-mobile">
      <div class="column is-8 is-offset-2">

        <div style="padding:1.2em">
          <div class="columns is-vcentered">
            <div class="column is-1 has-text-left">
              <h1> <strong> Rank </strong></h1>
            </div>

            <div class="column is-3">
              <h1> <strong> Players </strong> </h1>
            </div>

            <div class="column has-text-centered">
              <h1> <strong> Ratings </strong> </h1>
            </div>

            <div class="column has-text-centered">
              <h1> <strong> Wins </strong> </h1>
            </div>

            <div class="column is-1 has-text-centered">
              <h1> <strong> Draws </strong> </h1>
            </div>

            <div class="column has-text-centered">
              <h1> <strong> Losses </strong> </h1>
            </div>

            <div class="column has-text-centered">
              <h1> <strong> </strong> </h1>
            </div>
          </div>
        </div>

        <div class="card" v-for="(team, index) in leaderboard" :key="index">
          <div class="columns is-vcentered">
            <div class="column is-1 has-text-centered">
              <h1> <strong> {{team.rank}} </strong></h1>
            </div>

            <div class="column is-3">
              <h1> <a @click="openInfoModal(team.address)" class="">{{ team.name }}</a> </h1>
            </div>

            <div class="column has-text-centered">
              <h1> {{team.rating}} </h1>
            </div>

            <div class="column has-text-centered">
              <h1> {{team.wins}} </h1>
            </div>

            <div class="column is-1 has-text-centered">
              <h1> {{team.draws}} </h1>
            </div>

            <div class="column is-1 has-text-centered">
              <h1> {{team.losses}} </h1>
            </div>

            <div class="column">
              <div class="columns">
                <div class="column">
                  <b-button @click="openBetModal(team.name, team.address)" class="is-primary is-fullwidth"> Stake
                  </b-button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>


      <b-modal :active.sync='isBetModalActive'>
        <div class="column is-6 is-offset-3">
          <div class="card">
            <form @submit.prevent='approve()'>
              <h1 class="is-size-4"> Stake on <strong>{{betModalData.name}}</strong></h1> <br>
              <b-field label='Amount:'>
                <b-input class="is-large" required> </b-input>
              </b-field> <br>
              <b-button :loading='isButtonLoading' native-type='submit' class="is-fullwidth is-medium is-primary"> Bet
                Now </b-button>
            </form>
          </div>
        </div>
      </b-modal>

      <!-- info modal -->
      <div class="modal" id="infoModal">
        <div class="modal-background"></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">Team info</p>
            <button class="delete" aria-label="close" @click="closeInfoModal()"></button>
          </header>
          <section class="modal-card-body">
            <table class="table">
              <thead>
                <tr>
                  <th><abbr title="name">Name of Axie</abbr></th>
                  <th>birthDate</th>
                  <th>matronClass</th>
                  <th><abbr title="name">Picture</abbr></th>
                </tr>
              </thead>
              <tr v-for="(axie, index) in this.specificLeaderAxies" :key="index">
                <th>{{ axie.name }}</th>
                <td>{{ axie.birthDate }}</td>
                <td>{{ axie.matronClass }}</td>
                <img :src=axie.image alt="axie image" width="150px">
              </tr>
            </table>
          </section>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
  import axios from "axios";
  import Web3 from 'web3';

  import config from '~/configs/config'
  import BettingContractABI from '~/configs/contracts/BettingContractABI.js'
  import StandardERC20TokenABI from '~/configs/contracts/StandardERC20TokenABI.js'

  export default {
    name: "Buy",

    components: {},

    data() {
      return {
        axies: [],
        leaderboard: [],
        specificLeaderAxies: [],
        isBetModalActive: false,
        betModalData: {
          name: '',
          address: '',
          amount: ''
        },
        isLoggedIn: false,
        address: '',
        isButtonLoading: false
      };
    },

    methods: {
      async connectMetamask() {
        if (window.ethereum) {
          window.web3 = new Web3(ethereum);
          this.updateAccount()
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

      async updateAccount() {
        this.$store.commit('updateLoginState', true)
        this.address = web3.currentProvider.selectedAddress;
        console.log(this.$store.state.isLoggedIn)
      },

      async getLeaderboardData() {
        const leaderboardData = await axios.get(
          `https://api.axieinfinity.com/v1/battle/history/leaderboard`
        );
        this.leaderboard = leaderboardData.data;
      },

      async approve() {
        this.isButtonLoading = true
        const contract = new web3.eth.Contract(StandardERC20TokenABI, config.MATIC_DAI_ADDRESS)
        const approve = await contract.methods.approve(config.MATIC_BETTING_CONTRACT_ADDRESS, 10000).send({
            from: web3.currentProvider.selectedAddress
          })
          .then(response => console.log(response))
          .catch(err => {
            this.isButtonLoading = false
            this.$buefy.toast.open({
              duration: 2000,
              message: `Problem With Metamask`,
              position: 'is-top',
              type: 'is-warning'
            })
            }
          )
      },

      openBetModal(name, address) {
        this.isBetModalActive = true
        this.betModalData.name = name
        this.betModalData.address = address
      }

    },

    created() {
      this.connectMetamask()
    },

    async mounted() {
      this.getLeaderboardData()
    },
  };

</script>

<style lang="scss" scoped>
  .card {
    background-color: rgb(255, 255, 255);
    box-shadow: rgba(0, 0, 0, 0.09) 0px 1px 2px 0px, rgba(0, 0, 0, 0.05) 0px 4px 8px 0px;
    // height: 100%;
    border-radius: 8px;
    padding: 1em;
    margin-bottom: 20px;
  }

</style>
