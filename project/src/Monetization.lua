local RevMob = require("revmob");
RevMob.setTestingMode(RevMob.TEST_WITH_ADS)
local AMAZON_APK = false;

local REVMOB_IDS = {
      [REVMOB_ID_IOS] = '51e276c2f503ed575200013f',
      [REVMOB_ID_ANDROID] = '51e2774de6c67ad1e200003a',
    }
if AMAZON_APK then REVMOB_IDS[REVMOB_ID_ANDROID] = '51e27764b40e1f0e2600004f' end

RevMob.startSession(REVMOB_IDS);

local monetize = {}; local preLoadFullScreenAd; local display = display; local _W = display.contentWidth; local _H = display.contentHeight;
local preLoadAdLink;

monetize.createFullScreenAd = function()
   preLoadFullScreenAd = RevMob.createFullscreen();
end

monetize.startFullPageAdvert = function ()
  if (preLoadFullScreenAd ~= nil) then
      preLoadFullScreenAd:show();
  else
      RevMob.showFullscreen();
  end

end


monetize.showBannerAtTop = function()
  local banner = RevMob.createBanner();
  banner.width = 300;
  banner.height = 40;
  banner.x = _W-(banner.width/2);
  banner.y = banner.height/2;
end

monetize.createAdLink = function()
  preLoadAdLink = RevMob.createAdLink();
end

monetize.openAdLink = function()
  if preLoadAdLink then preLoadAdLink:open(); end
end


return monetize;

