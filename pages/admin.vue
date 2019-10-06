<template>
  <div class="column is-6 is-offset-3" style="height:90vh">
    <br> <br>

    <form>
      <h1 class="is-size-3"> Publish result for Tournament<strong> #{{tournamentId}} </strong></h1> <br>
      <b-field label="Winner">
        <b-input v-model="winner" placeholder="Address" size="is-medium" rounded></b-input>
      </b-field> <br>
      <b-button size="is-medium" @click='settle()' class="is-primary is-fullwidth">Settle</b-button>
    </form> <br> <br>
    <b-button class="is-primary" @click="addTournament()">Add Tournament</b-button>


  </div>
</template>

<script>
  import Web3 from 'web3';

  import config from '~/configs/config'
  import BettingContractABI from '~/configs/contracts/BettingContractABI.js'
  import StandardERC20TokenABI from '~/configs/contracts/StandardERC20TokenABI.js'

  export default {
    data() {
      return {
        tournamentId: '',
        winner: ''
      }
    },

    methods: {
      async connectMetamask() {
        if (window.ethereum) {
          window.web3 = new Web3(ethereum);
          //this.updateAccount()
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

      async addTournament() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        await contract.methods.addTournament().send({
            from: web3.currentProvider.selectedAddress
          })
          .then(Response => console.log(Response))
          .catch(err => console.log(err))
      },

      async getTournamentId() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        const tournamentId = await contract.methods.getTournamentId().call()
        this.tournamentId = tournamentId
      },

      async addPlayers() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        await contract.methods.addParticipants(this.playerArray, 101).send({
            from: web3.currentProvider.selectedAddress
          })
          .then(Response => console.log(Response))
          .catch(err => console.log(err))
      },

      async settle() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        await contract.methods.settle(this.tournamentId, this.winner).send({
            from: web3.currentProvider.selectedAddress
          })
          .then(Response => {
            this.$buefy.toast.open({
              duration: 2000,
              message: `Tournament Settled`,
              position: 'is-top',
              type: 'is-success'
            })
          })
          .catch(err => console.log(err))
      }
    },

    created() {
      this.connectMetamask()
    },

    mounted() {
      this.getTournamentId()
    }

  }

</script>
