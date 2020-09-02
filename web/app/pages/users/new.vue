<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="8" lg="6">
      <v-card>
        <v-subheader>新規ユーザー登録</v-subheader>

        <v-form ref="form">
          <v-card-text>
            <v-text-field label="ユーザー名" v-model="signupForm.name"></v-text-field>
            <v-text-field
              label="メールアドレス"
              v-model="signupForm.email"
              append-icon="mdi-email"
            ></v-text-field>
            <v-text-field label="パスワード"
              v-model="signupForm.password"
              :type="show ? 'text' : 'password'"
              class="input-group--focused"
              :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
              @click:append="show = !show"
            ></v-text-field>
            <!-- <v-text-field label="確認用パスワード" v-model="passwordConfirmation" type="password" class="input-group--focused"></v-text-field> -->
          </v-card-text>
        </v-form>

        <v-divider class="mt-12"></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-slide-x-reverse-transition></v-slide-x-reverse-transition>
          <v-btn @click="signupSubmit" color="primary" raised>新規ユーザー登録</v-btn>
        </v-card-actions>

        <v-divider class="mt-12"></v-divider>

        <v-card-actions>
          <v-btn to="/sessions/new" color="primary" text>すでにユーザー登録がお済みの方はこちら</v-btn>
        </v-card-actions>

      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  data () {
    return {
      signupForm: {
        name: '',
        email: '',
        password: '',
        // passwordConfirmation: '',
      },
      show: false,
    }
  },
  methods: {
    signupSubmit: async function () {
      try {
        const res = await this.$axios.$post('/api/v1/users', {
          user: this.signupForm
        })
        console.log(res.user);
        alert(`こんにちは、${res.data.name}`)
        this.$route.push({ path: "/sessions/new" })
      } catch (e) {
        alert(e.response.data.error)
      }
    }
  }
}

</script>
