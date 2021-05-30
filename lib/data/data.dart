class slidermodel {
  String imagepath;
  String title;
  String desc;

  slidermodel({this.imagepath, this.title, this.desc});


  void setImageAssetPath(String getImagePath) {
    imagepath = getImagePath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imagepath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

  List<slidermodel> getslides() {
    List<slidermodel> slides = new List<slidermodel>();
    slidermodel Slidermodel = new slidermodel();
    //1
    Slidermodel.setImageAssetPath("assets/images/diagnosis.png");
    Slidermodel.setTitle("Covid-19 Diagnosis");
    Slidermodel.setDesc("An instant COVID-19 diagnosis by accepting scans from your local laboratories and providing you with instant and effective results");
    slides.add(Slidermodel);

    Slidermodel = new slidermodel();

    //2
    Slidermodel.setImageAssetPath("assets/images/DifferentialDiagnosis.png");
    Slidermodel.setTitle("Covid-19 Differential Diagnosis");
    Slidermodel.setDesc("Allows you to perform your own COVID-19 symptom assessment after going through few questions in a short screening. If your condition changes, you can repeat the screening at any time. ");
    slides.add(Slidermodel);
    Slidermodel = new slidermodel();

    //3
    Slidermodel.setImageAssetPath("assets/images/undraw_Chat_bot_re_e2gj.png");
    Slidermodel.setTitle("Chatbot");
    Slidermodel.setDesc("A chatbot to help you relieve your stress and reduce depression and emotional baggage");
    slides.add(Slidermodel);

    Slidermodel = new slidermodel();

    //4
    Slidermodel.setImageAssetPath("assets/images/mobile_testing.png");
    Slidermodel.setTitle("Let's get started!!");
    Slidermodel.setDesc("");
    slides.add(Slidermodel);
    Slidermodel = new slidermodel();

    return slides;
  }
