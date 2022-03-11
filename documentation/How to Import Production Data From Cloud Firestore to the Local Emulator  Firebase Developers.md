![](https://miro.medium.com/max/700/0*VAwZFc8Umu1aezR3)

Photo by [Marc-Olivier Jodoin](https://unsplash.com/@marcojodoin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

## Optimizing Your Development Workflow

Recently, the Firebase team released the [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite), where you can play and test with your data without being afraid of production changes. It’s still in the early stage, but has a very cool UI and basically mirrors everything you need for development.

![Screenshot of the Firebase Local Emulator Suite](https://miro.medium.com/max/700/1*gDKX7xHwZYHDLqvMcXlqsw.png)

When I first tried to test it, I opened Firestore (as I use it preferably over the Realtime Database) and saw empty collections:

![Screenshot of the Firestore Emulator, with an empty collection](https://miro.medium.com/max/700/1*Zxtm2dFMsOq0S-jIDERbFA.png)

For some testing or development cases, this can be perfect, as you can just create some documents and collections right away and do the work, but more often than not you’ll want to **sync your production database with the local emulator.**

This gives you the possibility to actually **skip the creation of yet another project** just to hold a copy of your database for your development environment. Even more importantly, the Firebase Local Emulator Suite holds data locally (as the name implies), which leads to **completely free writes and reads**.

But like any story that starts too good, it has a couple of drawbacks and the problem here is that the official Firebase documentation only shows [how to export data from the local emulator and import it afterward](https://firebase.google.com/docs/emulator-suite/install_and_configure#export_and_import_emulator_data), which means you need to populate data first and you cannot use your production data. You can check out this great official [video from the #FirebaseLive](https://www.youtube.com/watch?v=pkgvFNPdiEs) series released on 5th July 2020 explaining all the new features for the Firebase Local Emulator Suite.

## How to Import Production Data Into the Local Emulator

We’ll do all work in the terminal, so make sure to install the G**oogle Cloud SDK** ([see how to](https://cloud.google.com/sdk/install)) and the F**irebase CLI** ([see how to](https://firebase.google.com/docs/cli)) before we begin.

1\. Login to Firebase and Google Cloud:

```
firebase logingcloud auth login
```

2\. See the list of your projects and connect to the one you’d like to export data from:

```
firebase projects:listfirebase use your-project-namegcloud projects listgcloud config set project your-project-name
```

3\. **Export your production data** to a Google Cloud Storage bucket, providing a name of your choice:

```
gcloud firestore export gs://your-project-name.appspot.com/your-choosen-folder-name
```

4\. Now **copy this folder to your local machine.** I usually do this directly from my project’s `functions` folder:

```
cd functionsgsutil -m cp -r gs://your-project-name.appspot.com/your-choosen-folder-name .
```

5\. **Now we just want to import this folder.** This should work with the basic command, thanks to the latest update from Firebase team [https://github.com/firebase/firebase-tools/pull/2519](https://github.com/firebase/firebase-tools/pull/2519).

```
firebase emulators:start --import ./your-choosen-folder-name
```

P.S To learn more about the individual commands, like:`gsutil, gcloud and firebase` you can always run them with `--help` flag.

I shared this answer on Stack Overflow earlier: [https://stackoverflow.com/questions/57838764/how-do-import-data-from-cloud-firestore-to-the-local-emulator](https://stackoverflow.com/questions/57838764/how-do-import-data-from-cloud-firestore-to-the-local-emulator)

## Can We Do Better? 🤔

Currently in step 3 when we are exporting the existing Firestore database, we are using the command : `gcloud firestore export gs://your-project-name.appspot.com/your-choosen-folder-name` where we are basically **pointing at our project bucket** which is not very nice because it will create `your-choosen-folder-name` in our project storage. Let’s create a bucket for the emulator in our Google Cloud project and use that instead:

1.  [Go to the Google Cloud Platform](https://console.cloud.google.com/) Storage browser

![](https://miro.medium.com/max/700/1*lt4DBYTY8L3NhfHC-h2VCQ.png)

2\. Click the _create_ button in the top menu and start filling out the form. You are probably not interested in the highest performance for this bucket as it will be used only in a development environment, so you can set up _Location type_ as _Region_, _Coldline storage class_ and as you basically want any developer with rights to access this bucket you can select _Uniform access control_ because you don’t want to set up strict rules per storage objects. Finally, select the _google-managed key_ and you are ready to go.

3\. Now you can use this bucket to export to, instead of the production bucket: `gcloud firestore export gs://your-emulator-bucket.appspot.com/your-choosen-folder-name` . If you created the emulator bucket in a different project, be sure to set up **IAM permissions** in the Google Cloud platform or by running this command:

```
gsutil iam ch serviceAccount:project-for-export@appspot.gserviceaccount.com:roles/storage.admin \  gs://production-project.appspot.com
```

## How We Simplify This Even Further?

I was thinking about how to make it **simple** for myself when developing locally and came up with a script solution which I need to run **just** **once** when I want to populate data from my production database and use it until I need updated data.

Let’s create this `start-up.bash` script file:

That will save some time in the future. Let’s add it to your `package.json` scripts:

```
"scripts": {  "start-up": "./folder-where-you-saved-script/start-up.bash",  "dev": "firebase emulators:start --import your-choosen-folder"},
```

## One Command to Rule them All 💪

Every time a new developer opens up a project or there is a need to re-sync the local database with production, we can simply execute `npm run start-up` , wait for it to finish and start our project with `npm run dev` as usually.

Obviously, as you make changes to the production data, our local copy in the emulator will go out of sync, but it’s easy enough to run the command again and get fresh data from production.

## Resources