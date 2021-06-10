
import 'dart:io';
import 'package:azaFashions/models/CelebrityList.dart';
import 'package:azaFashions/models/LandingPages/AzaMagzine.dart';
import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/models/LandingPages/FormBlock.dart';
import 'package:azaFashions/models/LandingPages/HoriItemListing.dart';
import 'package:azaFashions/models/LandingPages/SliderList.dart';
import 'package:azaFashions/models/LandingPages/VanillaBanner.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/azamagzine_widget.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BannerCards.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BannerCarouselPage.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BlockBanner.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BlockSlider.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BulletBlocks.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/CelebBlockSlider.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/FiveBlocksPage.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/FormBlockPage.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/GridBlock.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/HoriProductListing.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/LimitedCollection.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/OneCategorySlider.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/SliderPage.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/TwoBlocksPage.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/VanillaBannerPage.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:flutter/cupertino.dart';

class ChildLandingPage {
  String screen_title;
  List<Widget> other_layout;

  ListingModel collectionList;
  String error, success, page_name;
  BannerCarousel bannerCarousel, bannerCards;
  BannerCarousel fiveBlocks;
  FiveBlocks bulletBlocks;
  FiveBlocks twoBlocks;
  BannerCarousel oneBlockSlider;
  FiveBlocks blockSlider;
  FiveBlocks blockBanner;
  FiveBlocks gridBlock;
  VanillaBanner vanilla;
  HoriItemListing horiItemListing;
  SliderList slider;
  FormBlock formBlock;
  CelebrityList celebrityList;
  AzaMagzine azaMagzine;
  String view_all_url = "",
      view_all_urltag = "",
      main_viewtitle = "",
      insider_viewtitle = "";

  ChildLandingPage({this.bannerCarousel});

  ChildLandingPage.withError(String errorMessage) {
    error = errorMessage;
  }

  ChildLandingPage.withSuccess(String successMessage) {
    success = successMessage;
  }


  ChildLandingPage.fromJson(Map<String, dynamic> json, String tag) {
    if (json["data"]["cards"] != null) {
      other_layout = new List<Widget>();
      screen_title = json.toString().contains("screen_title")
          ? json["data"]["screen_title"]
          : "";
      json["data"]["cards"].forEach((v) {
        if (v["layout"] == "banner_carousel") {
          bannerCarousel = new BannerCarousel.fromJson(v);
          other_layout.add(BannerCarouselPage(banners: bannerCarousel),);
        }
        else if (v["layout"] == "banner_cards") {
          bannerCards = new BannerCarousel.fromJson(v);
          other_layout.add(BannerCards(banners: bannerCards),);

        }

        else if (v["layout"] == "blocks_with_banner_enclosure" ||
            v["layout"] == "1xbanner_x2blocks") {
          blockBanner = new FiveBlocks.fromJson(v);
          other_layout.add(Padding(padding: EdgeInsets.only(top: 20), child: BlockBanner(fiveBlocks: blockBanner, tag: "$tag"),),);
        }
        else if (v["layout"] == "2x_blocks") {
          gridBlock = new FiveBlocks.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 20),
            child: GridBlock(fiveBlocks: gridBlock, tag: "$tag"),
          ),);
        }
        else if (v["layout"] == "block_slider") {
          blockSlider = new FiveBlocks.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 5),
            child: BlockSlider(fiveBlocks: blockSlider, tag: "$tag"),
          ),);
        }
        else if (v["layout"] == "five_blocks") {
          fiveBlocks = new BannerCarousel.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 20),
            child: FiveBlocksPage(fiveBlocks: fiveBlocks, tag: "$tag"),
          ),);
        }


        else if (v["layout"] == "celebrity_block_slider") {
          celebrityList = new CelebrityList.fromJson(v,0);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 20),
            child: CelebBlockSlider(celebrityList: celebrityList, tag: "$tag"),
          ),);
        }

        else if (v["layout"] == "vanilla_banner") {
          vanilla = new VanillaBanner.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: VanillaBannerPage(banners: vanilla, tag: "$tag"),
          ),);
        }

        else if (v["layout"] == "3x2_bullet_blocks") {
          bulletBlocks = new FiveBlocks.fromJson(v);
          other_layout.add(BulletBlocks(bullet_blocks: bulletBlocks));
        }
        else if (v["layout"] == "two_blocks") {
          twoBlocks = new FiveBlocks.fromJson(v);
          other_layout.add(TwoBlocksPage(twoBlocks: twoBlocks),);
        }
        else if (v["layout"] == "1fix_slider") {
          oneBlockSlider = new BannerCarousel.fromJson(v);
          other_layout.add(OneCategorySlider(categorySlider: oneBlockSlider,));
        }

        else if (v["layout"] == "entity_showcase") {
          slider = new SliderList.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 20),
            child: SliderPage(slider: slider, tag: "$tag"),
          ),);
        }
        else if (v["layout"] == "products_slider") {
          horiItemListing = new HoriItemListing.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 5),
            child: HoriProductListing(
                horiItemListing: horiItemListing, tag: "$tag"),
          ),);
        }
        else if (v["layout"] == "wedding_inquiry") {
          formBlock = new FormBlock.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: FormBlockPage(blockItem: formBlock, tag: "$tag"),
          ),);
        }
        else if (v["layout"] == "magazine_slider") {
          azaMagzine = new AzaMagzine.fromJson(v);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 5, bottom: 20),
            child: MagzineWidget(azaMagzine),
          ),);
        }
        else if (v["layout"] == "collection") {
          collectionList = new ListingModel.fromJson(v, 0);
          other_layout.add(Padding(
            padding: EdgeInsets.only(top: 5, bottom: 20),
            child: LimitedCollection(collectionList),

          ),);
        }
      });
    }

    if(json.toString().contains("view_all") && json["data"]["view_all"] != null) {
      main_viewtitle = json["data"]["view_all"]["title"];
      view_all_url = json["data"]["view_all"]["url"];
      view_all_urltag = json["data"]["view_all"]["url_tag"];

      other_layout.add(Padding(
        padding:  EdgeInsets.only( bottom: Platform.isIOS?25:10,),
        child: ViewAllBtn(
            view_all_url, view_all_urltag, insider_viewtitle, main_viewtitle,
            ""),
      ));
    }
  }


}













