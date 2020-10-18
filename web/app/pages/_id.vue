<template>
  <div ref="content" class="content">
    <h1>詳細</h1>
    <img :src="picList[this.id]" ref="targetImage" width="50%" />
    <p>{{ feed.title }}</p>
  </div>
</template>

<script>
import { getAbsolutePosition } from "~/plugins/getAbsolutePosition";
import anime from "animejs/lib/anime.es.js";
export default {
  data() {
    return {
      id: this.$route.params.id,
      pass: this.$route.params.pass,
      picList: [
        // "img01@2x.jpg",
        // "img02@2x.jpg",
        // "img03@2x.jpg",
        // "img04@2x.jpg",
        // "img05@2x.jpg",
      ],
      feeds: [],
      feed: {},
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
        this.feeds.push(res4.feed);
        const picList = [];
        const feedTitle = [];
        this.feeds.forEach((feed) => picList.push(feed.image));
        this.feeds.forEach((feed) => feedTitle.push(feed.title));
        this.picList = picList;
        this.feedTitle = feedTitle;
        console.log(`このfeedは,${this.picList}`);
      }
    }
  },
  beforeRouteEnter(to, from, next) {
    if (from.name === null) {
      next((vm) => {
        //vm.styleObj.opacity = 1;
        console.log("this:", vm);
        anime({
          targets: vm.$refs.content,
          opacity: [0, 1],
          easing: "easeInOutQuart",
          duration: 800,
          complete: () => {
            console.log("content show complete");
          },
        });
      });
    } else {
      // 遷移時にアニメーションを実行
      next((vm) => vm.setImageData());
    }
  },

  beforeRouteLeave(to, from, next) {
    // クリックした記事の情報を取得
    const component = this.$refs.targetImage;
    // 遷移前の画像の位置を取得
    const src = component.src;
    console.log("src:", src);
    const pos = getAbsolutePosition(component);
    console.log(pos);
    const styleObj = {
      top: `${pos.top}px`,
      left: `${pos.left}px`,
      width: `${component.clientWidth}px`,
    };
    // ダミー画像に位置と画像のURLを渡す
    this.$nuxt.$emit("layoutImage", {
      src: src,
      styleObj: styleObj,
    });
    const scrollElement =
      window.document.scrollingElement ||
      window.document.body ||
      window.document.documentElement;
    // ページを上部に移動
    anime({
      targets: scrollElement,
      scrollTop: 0,
      easing: "easeInOutQuart",
      duration: 800,
      complete: () => {
        console.log("scrollTop complete");
      },
    });
    // ページの不透明度を0にアニメーション
    anime({
      targets: this.$refs.content,
      opacity: [1, 0],
      easing: "easeInOutQuart",
      duration: 800,
      complete: () => {
        next();
      },
    });
  },
  methods: {
    setImageData() {
      const node = this.$refs.targetImage;
      // const wrapRect = this.$refs.content.getBoundingClientRect();
      const itemRect = getAbsolutePosition(node);
      console.log("itemRect", itemRect);

      // 遷移後の画像の位置を取得
      const styleObj = {
        top: `${itemRect.top /*  - wrapRect.top */}px`,
        left: `${itemRect.left /*  - wrapRect.left */}px`,
        width: `${node.clientWidth}px`,
      };

      node.style.opacity = 0;

      // ダミー画像に情報を渡す
      Promise.resolve(
        this.$nuxt.$emit("layoutImageMove", {
          styleObj: styleObj,
          node: node,
        })
      ).then(() => {
        // ページの不透明度を1にする
        anime({
          targets: this.$refs.content,
          opacity: [0, 1],
          easing: "easeInOutQuart",
          duration: 800,
          complete: () => {
            console.log("content show complete");
          },
        });
      });
    },
  },
};
</script>

<style>
.content {
  opacity: 0;
}
</style>
