<template>
    <section class="section">
        <div class="container">
            <div class="field">
                <label class="label">Axie Id</label>
                <div class="control">
                    <input class="input" type="text" placeholder="Text input" v-model="axieId">
                </div>
            </div>

            <div class="field">
                <label class="label">Number of Shares</label>
                <div class="control">
                    <input class="input" type="number" placeholder="#Shares" value="0" v-model="noOfShares">
                </div>
            </div>

            <div class="field">
                <label class="label">Price per share (in USD)</label>
                <div class="control">
                    <input class="input" type="number" placeholder="Price" value="0" v-model="pricePerShare">
                </div>
            </div>

            <div class="field">
                <label class="label">How much share do you want to retain?</label>
                <div class="control">
                    <input class="input" type="number" placeholder="Retain" value="0" v-model="noOfRetainShares">
                </div>
            </div>

            <div class="field is-grouped">
                <div class="control">
                    <button class="button is-link" @click="onSubmit()">Submit</button>
                </div>
            </div>
        </div>
    </section>
</template>

<script>
import Card from "~/components/Card";

export default {
  name: "Add",

  components: {
    Card
  },

  methods: {
    onSubmit() {
      this.$buefy.toast.open({
        message:
          "Added an axie successfully.",
        type: "is-success"
      });
    }
  }
};
</script>
