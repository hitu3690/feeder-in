<template>
  <v-dialog v-model="dialog" max-width="600px">
    <template v-slot:activator="{ on, attrs }">
      <v-btn v-on="on" v-bind="attrs">記事を追加</v-btn>
      <v-container>
        <!-- feedがある場合 -->
        <v-row v-if="feeds.length">
          <!-- feed本体 -->
          <v-col cols="4" v-for="feed in feeds" :key="feed.id">
            <v-card>
              <!-- feed画像 -->
              <v-img src="/img02@2x.jpg" height="200px"></v-img>
              <!-- feedタイトル -->
              <v-card-title><a :href="feed.url">{{ feed.title }}</a></v-card-title>
              <!-- feedボタン群 -->
              <v-card-actions>
                <v-btn @click="show = !show" icon>
                  <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
                </v-btn>
              </v-card-actions>
              <!-- items本体 -->
              <v-expand-transition>
                <div v-show="show">
                  <v-divider></v-divider>
                  <v-card-text>
                    <!-- items一覧 -->
                    <ul>
                      <li v-for="item in feed.items">
                        <!-- itemタイトル -->
                        <a href="item.url">{{ item.title }}</a>
                      </li>
                    </ul>
                  </v-card-text>
                </div>
              </v-expand-transition>
            </v-card>
          </v-col>
        </v-row>
        <v-row v-else>
          <v-col cols="4">
            <v-card>
              <v-img src="/img02@2x.jpg" height="200px"></v-img>
              <v-card-title>記事を追加してください</v-card-title>
              <v-card-actions>
                <v-btn @click="show = !show" icon>
                  <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
                </v-btn>
              </v-card-actions>
              <v-expand-transition>
                <div v-show="show">
                  <v-divider></v-divider>
                  <v-card-text>
                    <ul>
                      <li>
                        <a href="https://news.yahoo.co.jp/rss">記事を追加してください</a>
                      </li>
                    </ul>
                  </v-card-text>
                </div>
              </v-expand-transition>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </template>
    <!-- ダイアログ本体 -->
    <v-card>
      <v-card-text>
        <v-container>
          <v-row>
            <v-col cols="12">
              <v-text-field label="RSS" v-model="rssForm.url" required></v-text-field>
            </v-col>
          </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="blue" text @click="dialog = false">Close</v-btn>
        <v-btn color="blue" text @click="addFeed">追加</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data () {
    return {
      dialog: false,
      show: false,
      feeds: [],
      rssForm: {
        url: '',
      },
      // feedTitle: '',
      // feedUrl: '',
      // feedImage: '',
      // feedItems: [],
      // itemUrl: '',
    }
  },
  methods: {
    addFeed: async function () {
      // 記事を追加
      const res1 = await this.$axios.$post('/api/v1/feeds', {
        feed: this.rssForm
      })
      console.log(res1.status);
      this.dialog = false
      this.rssForm = ''
      // 記事を描画
      const res2 = await this.$axios.$get(`/api/v1/feeds/${res1.id}`)
      console.log(res2.feed.title);
      this.feeds.push(res2.feed)
      // this.feedTitle = res2.feed.title
      // this.feedUrl = res2.feed.url
      // // this.feedImage = res2.feed.image
      // this.feedItems = res2.feed.items
    },
    showItems: function (id) {
      alert(`ここは、${id}ボタンです`)
    },
  },
  created: async function() {
    const res3 = await this.$axios.$get('/api/v1/feeds')
    console.log(res3.data);
    for (let i = 0; i < res3.data.length; i++) {
      const res4 = await this.$axios.$get(`/api/v1/feeds/${res3.data[i].id}`)
      console.log(res4.feed);
      this.feeds.push(res4.feed)
    }
  },
  // watch: {
  //   feeds: {
  //     handler: function () {
  //       this.feeds
  //     }
  //   }
  // },
}
</script>

<style media="screen">

</style>
