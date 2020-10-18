<template>
  <v-dialog v-model="dialog" max-width="600px">
    <template v-slot:activator="{ on, attrs }">
      <v-container>
        <!-- feedがある場合 -->
        <draggable
          tag="v-row"
          :options="{ animation: 300 }"
          @sort="onSort"
          v-model="feeds"
        >
          <!-- feed本体 -->
          <v-col cols="4" v-for="(feed, index) in feeds" :key="index">
            <v-card>
              <!-- feed画像 -->
              <v-img
                v-show="feed.image.length"
                :src="feed.image"
                height="200px"
              ></v-img>
              <v-img
                v-show="!feed.image.length"
                src="rss_default.jpg"
                height="200px"
              ></v-img>
              <!-- feedタイトル -->
              <v-card-title
                ><a
                  :href="feed.url"
                  target="_blank"
                  rel="noopener noreferrer"
                  >{{ feed.title }}</a
                ></v-card-title
              >
              <!-- feedボタン群 -->
              <v-card-actions>
                <v-btn @click="feed.show = !feed.show" icon>
                  <v-icon>{{
                    feed.show ? "mdi-chevron-up" : "mdi-chevron-down"
                  }}</v-icon>
                </v-btn>
                <v-btn @click="deleteFeed(index)" icon>
                  <v-icon>mdi-close</v-icon>
                </v-btn>
              </v-card-actions>
              <!-- items本体 -->
              <v-expand-transition>
                <div v-show="feed.show">
                  <v-divider></v-divider>
                  <v-card-text>
                    <!-- items一覧 -->
                    <ul>
                      <li v-for="item in feed.items" :key="item.id">
                        <!-- itemタイトル -->
                        <a
                          :href="item.url"
                          target="_blank"
                          rel="noopener noreferrer"
                          >{{ item.title }}</a
                        >
                      </li>
                    </ul>
                  </v-card-text>
                </div>
              </v-expand-transition>
            </v-card>
          </v-col>
          <v-col cols="4" class="ma-2">
            <v-btn v-on="on" v-bind="attrs" x-large>
              <v-icon large>mdi-plus</v-icon>
            </v-btn>
          </v-col>
        </draggable>
      </v-container>
    </template>
    <!-- ダイアログ本体 -->
    <v-card>
      <v-card-text>
        <v-container>
          <v-row>
            <v-col cols="12">
              <v-text-field
                label="RSS"
                v-model="rssForm.url"
                required
              ></v-text-field>
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
import draggable from "vuedraggable";

export default {
  components: {
    draggable,
  },
  data() {
    return {
      dialog: false,
      // show: false,
      feeds: [],
      rssForm: {
        url: "",
      },
    };
  },
  mounted: async function () {
    const res3 = await this.$axios.$get("/api/v1/feeds");
    if (res3.status == "error") {
      alert(res3.data);
      this.$router.push({ path: "sessions/new" });
    } else {
      for (let i = 0; i < res3.data.length; i++) {
        const res4 = await this.$axios.$get(`/api/v1/feeds/${res3.data[i].id}`);
        console.log(res4.feed);
        this.feeds.push(res4.feed);
      }
    }
  },
  methods: {
    async addFeed() {
      // 記事を追加
      const res1 = await this.$axios.$post("/api/v1/feeds", {
        feed: this.rssForm,
      });
      this.dialog = false;
      this.rssForm = "";
      // 記事を描画
      const res2 = await this.$axios.$get(`/api/v1/feeds/${res1.id}`);
      this.feeds.push(res2.feed);
      const res6 = await this.$axios.$post("/api/v1/feeds/sort", {
        feed: this.feeds,
      });
      console.log(res2);
    },
    async onSort(e) {
      const res5 = await this.$axios.$post("/api/v1/feeds/sort", {
        feed: this.feeds,
      });
      console.log(res5);
      console.log(e);
    },
    async deleteFeed(index) {
      console.log(`${index}:${this.feeds[index].id}`);
      const res7 = await this.$axios.$delete(
        `/api/v1/feeds/${this.feeds[index].id}`
      );
      this.feeds.splice(index, 1);
      return console.log(res7.status);
    },
  },
  computed: {
    user() {
      return this.$store.getters[`user`];
    },
  },
};
</script>

<style media="screen">
</style>
