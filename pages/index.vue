<template>
  <section class="section">
    <div class="columns is-mobile">
      <div class="column is-8 is-offset-2">

        <div class="columns">
          <div class="column header-card has-text-centered" style="margin:1em;">
            <img src="https://image.flaticon.com/icons/svg/1170/1170611.svg" style="width:22px;margin-bottom:-5px;" />
            Tournament ID <strong> #{{tournamentId}} </strong>
          </div>

          <div class="column  header-card has-text-centered" style="margin:1em;">
            Total Value Locked: <strong>{{lockedValue}} <img src="https://instadapp.io/earn/img/icons/tokens/dai.svg"
                style="width:18px;margin-bottom:-4px" /> </strong>
          </div>
        </div>

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
              <h1> <a @click="getAxiesByLeaderAddress(team.address)" class="">{{ team.name }}</a> </h1>
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
            <div v-if="isBetSuccess" class="has-text-centered" style="padding: 2em 0em">
              <img src='~assets/success.svg' style="width:200px;margin-bottom:3em" />
              <h1 class="subtitle">Hurray! Bet Successful </h1>
            </div>

            <div v-else>
              <form @submit.prevent='approve()'>
                <h1 class="is-size-4"> Stake on <strong>{{betModalData.name}}</strong></h1> <br>
                <b-field label='Amount in Dai:'>
                  <b-input v-model="betModalData.amount" class="is-large" required> </b-input>
                </b-field> <br>
                <b-button :loading='isButtonLoading' native-type='submit' class="is-fullwidth is-medium is-primary"> Bet
                  Now </b-button>
              </form>
            </div>
          </div>
        </div>
      </b-modal>

      <!-- info modal -->
      <b-modal :active.sync='isAxieModalActive'>
        <div class="card">
          <div class="columns is-vcentered">
            <div class="column has-text-weight-semibold	">
              Image
              <!-- {{axie}} -->
            </div>
            <div class="column has-text-weight-semibold	">
              Name
            </div>

            <div class="column has-text-weight-semibold	">
              MatronClass
            </div>

            <div class="column has-text-weight-semibold	  ">
              Properties
            </div>
          </div>
        </div>

        <div class="card column" style="background: rgb(244, 245, 246);">
          <div v-for='(axie, index) in specificLeaderAxies' :key='index'>
            <div class="card">
              <div class="columns is-vcentered">
                <div class="column">
                  <img :src="axie.image" style="width:130px" />
                  <!-- {{axie}} -->
                </div>
                <div class="column">
                  {{axie.name}}
                </div>

                <div class="column">
                  {{axie.matronClass.toUpperCase()}}
                </div>

                <div class="column">
                  {{ axie.stats ? Object.keys(axie.stats).map(stat => `${stat} -> ${axie.stats[stat]}`).join(', ') : ''}}
                </div>
              </div>
            </div>
          </div>
        </div>
      </b-modal>
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
        isButtonLoading: false,
        tournamentId: '',
        lockedValue: '',
        isBetSuccess: false,
        isAxieModalActive: false
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
        const amount = web3.utils.toWei(this.betModalData.amount, 'ether');

        const contract = new web3.eth.Contract(StandardERC20TokenABI, config.MATIC_DAI_ADDRESS)
        await contract.methods.approve(config.MATIC_BETTING_CONTRACT_ADDRESS, amount).send({
            from: web3.currentProvider.selectedAddress
          })
          .then(response => {
            this.bet(amount)
          })
          .catch(err => {
            this.isButtonLoading = false
            this.$buefy.toast.open({
              duration: 2000,
              message: `Problem With Metamask`,
              position: 'is-top',
              type: 'is-warning'
            })
          })
      },

      async bet(amount) {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        console.log(this.betModalData.address)
        contract.methods.bet(parseInt(this.tournamentId), this.betModalData.address, amount).send({
            from: web3.currentProvider.selectedAddress
          })
          .then(response => {
            console.log(response)
            this.isBetSuccess = true
            this.isButtonLoading = false
            this.getTotalValue()
          })
          .catch(err => {
            this.isButtonLoading = false
            this.$buefy.toast.open({
              duration: 2000,
              message: `Problem With Metamask`,
              position: 'izs-top',
              type: 'is-warning'
            })
          })

      },

      async getTournamentId() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        const tournamentId = await contract.methods.getTournamentId().call()
        this.tournamentId = tournamentId
      },

      async getTotalValue() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        const totalBet = await contract.methods.getTotalBet(this.tournamentId).call()
        this.lockedValue = web3.utils.fromWei(totalBet, 'ether');
      },

      openBetModal(name, address) {
        this.isBetModalActive = true
        this.betModalData.name = name
        this.betModalData.address = address
      },

      async getAxiesByLeaderAddress(leaderAddress) {
        const allAxiesForLeader = await axios.get(`https://axieinfinity.com/api/v2/addresses/${leaderAddress}/axies`);
        this.specificLeaderAxies = allAxiesForLeader.data.axies
        this.isAxieModalActive = true
      },

      async getSaneAxieData(stats) {

      }

    },

    created() {
      this.connectMetamask()
    },

    async mounted() {
      this.getLeaderboardData(),
        await this.getTournamentId()
      this.getTotalValue()
    },
  };

</script>

<style lang="scss" scoped>
  @import "~assets/main.scss";


  .card {
    background-color: rgb(255, 255, 255);
    box-shadow: rgba(0, 0, 0, 0.09) 0px 1px 2px 0px, rgba(0, 0, 0, 0.05) 0px 4px 8px 0px;
    // height: 100%;
    border-radius: 8px;
    padding: 1em;
    margin-bottom: 20px;
  }

  .header-card {
    background-color: rgb(255, 255, 255);
    box-shadow: rgba(0, 0, 0, 0.09) 0px 1px 2px 0px, rgba(0, 0, 0, 0.05) 0px 4px 8px 0px;
    // height: 100%;
    border-radius: 8px;
    padding: 1em;
    margin-bottom: 20px;
    border: 1px solid $primary;
  }

</style>
