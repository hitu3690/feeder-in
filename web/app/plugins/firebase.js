import firebase from "firebase/app"
import "firebase/auth"

const firebaseConfig = {
  apiKey: "AIzaSyBmGkDWdhNgldc-ncT8DkhsS8C5IYcTf-w",
  authDomain: "feeder-in.firebaseapp.com",
  databaseURL: "https://feeder-in.firebaseio.com",
  projectId: "feeder-in",
  storageBucket: "feeder-in.appspot.com",
  messagingSenderId: "550673835055",
  appId: "1:550673835055:web:7f6902fbadc30b774712da",
  measurementId: "G-YJMQMQM4YQ"
};
firebase.initializeApp(firebaseConfig)

export default firebase
