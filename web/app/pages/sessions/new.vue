<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="8" lg="6">
      <v-card>
        <v-subheader>ログイン</v-subheader>

        <v-form ref="form">
          <v-card-text>
            <v-text-field
              label="メールアドレス"
              v-model="loginForm.email"
              append-icon="mdi-email"
            ></v-text-field>
            <v-text-field label="パスワード"
              v-model="loginForm.password"
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
          <v-btn @click="loginSubmit" color="primary" raised>ログイン</v-btn>
        </v-card-actions>

        <v-divider class="mt-12"></v-divider>

        <v-card-actions>
          <v-btn to="/users/new" color="primary" text>まだユーザー登録がお済みでないの方はこちら</v-btn>
        </v-card-actions>

      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  data () {
    return {
      loginForm: {
        email: '',
        passowrd: '',
      },
      show: false
    }
  },
  methods: {
    loginSubmit: async function () {
      try {
        const res = await this.$axios.$post('/api/v1/sessions', {
          session: this.loginForm
        })
        console.log(res.status);
        alert(`こんにちは、${res.data.name}`)
        this.$route.push({ path: "/feeds" })
      } catch (e) {
        // console.log(e.response);
      }
    }
  }
}

</script>
