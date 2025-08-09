//
//  URLValidator.swift
//  URLValidator
//
//  A comprehensive URL validation and classification library for Swift.
//  Intelligently detects platforms, media types, and validates URLs using
//  native Apple APIs and UTType for maximum compatibility.
//
//  Created by Your Name
//  Copyright © 2024. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

/// A comprehensive URL validator that detects platforms, media types, and validates URLs
public struct URLValidator {
    
    // MARK: - File Extension Constants
    
    /// Audio file extensions that may not be recognized by UTType
    /// These are formats commonly used but not always properly detected by the system
    private static let audioExtensions: Set<String> = [
        // Open formats
        "ogg", "oga", "opus",
        // Lossless formats
        "ape", "wv", "tta",
        // Theater/streaming formats
        "dts", "ac3", "eac3",
        // Flash audio
        "f4a"
    ]
    
    /// Video file extensions that may not be recognized by UTType
    /// These are formats commonly used but not always properly detected by the system
    private static let videoExtensions: Set<String> = [
        // Container formats
        "mkv", "webm",
        // Legacy formats
        "flv", "vob", "ogv",
        // Camera formats
        "m2ts", "mts",
        // Flash video
        "f4v", "f4p"
    ]
    
    // MARK: - Platform Patterns
    
    /// Platform detection patterns using modern Swift
    private static let platformPatterns: [Platform: Set<String>] = {
        var patterns: [Platform: Set<String>] = [:]
        
        // Video Platforms
        patterns[.youtube] = ["youtube.com", "m.youtube.com", "youtu.be", "youtube-nocookie.com"]
        patterns[.youtubeMusic] = ["music.youtube.com"]
        patterns[.youtubeStudio] = ["studio.youtube.com"]
        patterns[.vimeo] = ["vimeo.com", "player.vimeo.com"]
        patterns[.dailymotion] = ["dailymotion.com", "dai.ly"]
        patterns[.twitch] = ["twitch.tv", "clips.twitch.tv", "m.twitch.tv"]
        patterns[.kick] = ["kick.com"]
        patterns[.rumble] = ["rumble.com"]
        patterns[.bitchute] = ["bitchute.com"]
        patterns[.odysee] = ["odysee.com"]
        patterns[.lbry] = ["lbry.tv", "lbry.com"]
        patterns[.peertube] = ["peertube.tv", "framatube.org", "tilvids.com"]
        patterns[.dtube] = ["d.tube"]
        patterns[.veoh] = ["veoh.com"]
        patterns[.metacafe] = ["metacafe.com"]
        patterns[.brighteon] = ["brighteon.com"]
        patterns[.banned] = ["banned.video"]
        patterns[.rokfin] = ["rokfin.com"]
        patterns[.floatplane] = ["floatplane.com"]
        patterns[.nebula] = ["nebula.tv", "nebula.app"]
        
        // Short-form Video
        patterns[.tiktok] = ["tiktok.com", "vm.tiktok.com", "m.tiktok.com", "vt.tiktok.com"]
        patterns[.instagram] = ["instagram.com", "instagr.am", "ig.me"]
        patterns[.snapchat] = ["snapchat.com", "snap.com", "snapchat.co"]
        patterns[.douyin] = ["douyin.com"]
        patterns[.kuaishou] = ["kuaishou.com"]
        patterns[.likee] = ["likee.video", "like.video"]
        patterns[.triller] = ["triller.co", "triller.com"]
        patterns[.byte] = ["byte.co"]
        patterns[.clash] = ["clash.co", "clash.me"]
        
        // Audio/Music
        patterns[.spotify] = ["spotify.com", "open.spotify.com", "play.spotify.com", "spotify.link"]
        patterns[.appleMusic] = ["music.apple.com", "itunes.apple.com"]
        patterns[.applePodcasts] = ["podcasts.apple.com"]
        patterns[.soundcloud] = ["soundcloud.com", "on.soundcloud.com", "m.soundcloud.com"]
        patterns[.bandcamp] = ["bandcamp.com"]
        patterns[.deezer] = ["deezer.com", "deezer.page.link", "dzr.fm"]
        patterns[.tidal] = ["tidal.com", "listen.tidal.com"]
        patterns[.amazonMusic] = ["music.amazon.com", "music.amazon.co.uk", "music.amazon.de"]
        patterns[.pandora] = ["pandora.com", "pandora.app.link"]
        patterns[.audiomack] = ["audiomack.com"]
        patterns[.qobuz] = ["qobuz.com", "play.qobuz.com", "open.qobuz.com"]
        patterns[.mixcloud] = ["mixcloud.com"]
        patterns[.beatport] = ["beatport.com"]
        patterns[.napster] = ["napster.com"]
        patterns[.iheartradio] = ["iheart.com", "iheartradio.com"]
        patterns[.tunein] = ["tunein.com"]
        patterns[.anghami] = ["anghami.com", "play.anghami.com"]
        patterns[.gaana] = ["gaana.com"]
        patterns[.jiosaavn] = ["jiosaavn.com", "saavn.com"]
        patterns[.lastfm] = ["last.fm", "lastfm.com"]
        patterns[.genius] = ["genius.com"]
        
        // Podcasts
        patterns[.anchor] = ["anchor.fm"]
        patterns[.podcastsSpotify] = ["podcasters.spotify.com"]
        patterns[.pocketCasts] = ["pocketcasts.com", "pca.st"]
        patterns[.overcast] = ["overcast.fm"]
        patterns[.castbox] = ["castbox.fm"]
        patterns[.googlePodcasts] = ["podcasts.google.com"]
        patterns[.stitcher] = ["stitcher.com"]
        patterns[.podbean] = ["podbean.com"]
        patterns[.buzzsprout] = ["buzzsprout.com"]
        patterns[.podcastAddict] = ["podcastaddict.com"]
        patterns[.castro] = ["castro.fm"]
        
        // Social Media
        patterns[.facebook] = ["facebook.com", "m.facebook.com", "fb.com", "fb.me", "fb.watch", "business.facebook.com"]
        patterns[.twitter] = ["twitter.com", "x.com", "t.co", "mobile.twitter.com", "mobile.x.com"]
        patterns[.linkedin] = ["linkedin.com", "lnkd.in"]
        patterns[.reddit] = ["reddit.com", "redd.it", "old.reddit.com", "np.reddit.com", "i.reddit.com"]
        patterns[.pinterest] = ["pinterest.com", "pin.it", "pinterest.co.uk", "pinterest.ca"]
        patterns[.tumblr] = ["tumblr.com", "tmblr.co"]
        patterns[.mastodon] = ["mastodon.social", "mastodon.online", "mstdn.social", "fosstodon.org", "mas.to"]
        patterns[.threads] = ["threads.net"]
        patterns[.bluesky] = ["bsky.app", "bsky.social", "blueskyweb.xyz"]
        patterns[.truthSocial] = ["truthsocial.com", "truthsocial.tv"]
        patterns[.gab] = ["gab.com", "gab.ai"]
        patterns[.parler] = ["parler.com"]
        patterns[.mewe] = ["mewe.com"]
        patterns[.gettr] = ["gettr.com"]
        patterns[.minds] = ["minds.com"]
        patterns[.locals] = ["locals.com"]
        patterns[.vero] = ["vero.co"]
        patterns[.ello] = ["ello.co"]
        patterns[.diaspora] = ["diasporafoundation.org", "joindiaspora.com"]
        
        // Asian Platforms
        patterns[.weibo] = ["weibo.com", "weibo.cn", "s.weibo.com"]
        patterns[.wechat] = ["wechat.com", "weixin.qq.com"]
        patterns[.qq] = ["qq.com", "im.qq.com"]
        patterns[.xiaohongshu] = ["xiaohongshu.com", "xhslink.com"]
        patterns[.bilibili] = ["bilibili.com", "b23.tv", "bilibili.tv"]
        patterns[.youku] = ["youku.com", "v.youku.com"]
        patterns[.niconico] = ["nicovideo.jp", "nico.ms"]
        patterns[.kakaotalk] = ["kakao.com", "kakaocorp.com"]
        patterns[.line] = ["line.me"]
        patterns[.viber] = ["viber.com"]
        patterns[.zalo] = ["zalo.me"]
        patterns[.vk] = ["vk.com", "vk.ru"]
        
        // Messaging
        patterns[.whatsapp] = ["whatsapp.com", "wa.me", "wa.link", "api.whatsapp.com", "web.whatsapp.com", "chat.whatsapp.com"]
        patterns[.telegram] = ["telegram.org", "t.me", "telegram.me", "telegram.dog"]
        patterns[.discord] = ["discord.com", "discord.gg", "discordapp.com", "discord.co", "discord.new"]
        patterns[.slack] = ["slack.com", "app.slack.com"]
        patterns[.signal] = ["signal.org", "signal.me"]
        patterns[.messenger] = ["messenger.com", "m.me"]
        patterns[.element] = ["element.io", "app.element.io"]
        patterns[.matrix] = ["matrix.org", "matrix.to"]
        patterns[.threema] = ["threema.ch"]
        patterns[.wire] = ["wire.com"]
        patterns[.session] = ["getsession.org"]
        patterns[.keybase] = ["keybase.io"]
        
        // Live Streaming
        patterns[.facebookGaming] = ["fb.gg", "gaming.fb.com"]
        patterns[.youtubeGaming] = ["gaming.youtube.com"]
        patterns[.dlive] = ["dlive.tv"]
        patterns[.caffeine] = ["caffeine.tv"]
        patterns[.trovo] = ["trovo.live"]
        patterns[.picarto] = ["picarto.tv"]
        patterns[.younow] = ["younow.com"]
        patterns[.bigoLive] = ["bigo.tv"]
        patterns[.streamyard] = ["streamyard.com"]
        patterns[.streamlabs] = ["streamlabs.com"]
        patterns[.restream] = ["restream.io"]
        patterns[.obsLive] = ["obs.live"]
        
        // Developer
        patterns[.github] = ["github.com", "gist.github.com", "raw.githubusercontent.com", "github.io"]
        patterns[.gitlab] = ["gitlab.com"]
        patterns[.bitbucket] = ["bitbucket.org", "bitbucket.com"]
        patterns[.stackoverflow] = ["stackoverflow.com", "stackexchange.com"]
        patterns[.codepen] = ["codepen.io", "cdpn.io"]
        patterns[.codesandbox] = ["codesandbox.io"]
        patterns[.replit] = ["replit.com", "repl.it", "repl.co"]
        patterns[.figma] = ["figma.com"]
        patterns[.dribbble] = ["dribbble.com"]
        patterns[.behance] = ["behance.net"]
        patterns[.angellist] = ["angel.co", "angellist.com"]
        patterns[.producthunt] = ["producthunt.com"]
        patterns[.polywork] = ["polywork.com"]
        patterns[.wellfound] = ["wellfound.com"]
        patterns[.glitch] = ["glitch.com", "glitch.me"]
        patterns[.kaggle] = ["kaggle.com"]
        patterns[.vercel] = ["vercel.com", "vercel.app"]
        patterns[.netlify] = ["netlify.com", "netlify.app"]
        
        // E-commerce
        patterns[.amazon] = ["amazon.com", "amazon.co.uk", "amazon.de", "amazon.fr", "amazon.it", "amazon.es", "amazon.ca", "amazon.in", "amazon.co.jp", "amzn.to", "amzn.eu"]
        patterns[.ebay] = ["ebay.com", "ebay.co.uk", "ebay.de", "ebay.fr", "ebay.it", "ebay.es", "ebay.ca", "ebay.com.au", "ebay.to"]
        patterns[.etsy] = ["etsy.com"]
        patterns[.shopify] = ["myshopify.com", "shopify.com", "shop.app"]
        patterns[.alibaba] = ["alibaba.com", "1688.com"]
        patterns[.aliexpress] = ["aliexpress.com", "aliexpress.ru"]
        patterns[.mercari] = ["mercari.com", "mercari.jp"]
        patterns[.poshmark] = ["poshmark.com", "poshmark.ca"]
        patterns[.depop] = ["depop.com"]
        patterns[.walmart] = ["walmart.com"]
        patterns[.target] = ["target.com"]
        patterns[.bestbuy] = ["bestbuy.com"]
        patterns[.wish] = ["wish.com"]
        patterns[.shein] = ["shein.com"]
        patterns[.wayfair] = ["wayfair.com"]
        
        // Gaming
        patterns[.steam] = ["store.steampowered.com", "steamcommunity.com", "steam.com"]
        patterns[.epicGames] = ["epicgames.com", "store.epicgames.com"]
        patterns[.battlenet] = ["battle.net", "blizzard.com"]
        patterns[.origin] = ["origin.com", "ea.com"]
        patterns[.uplay] = ["uplay.com", "ubisoft.com"]
        patterns[.gog] = ["gog.com"]
        patterns[.itchIo] = ["itch.io"]
        patterns[.roblox] = ["roblox.com"]
        patterns[.minecraft] = ["minecraft.net"]
        patterns[.fortnite] = ["fortnite.com"]
        patterns[.leagueOfLegends] = ["leagueoflegends.com"]
        patterns[.valorant] = ["playvalorant.com"]
        patterns[.xbox] = ["xbox.com"]
        patterns[.playstation] = ["playstation.com"]
        patterns[.nintendo] = ["nintendo.com"]
        
        // Financial
        patterns[.paypal] = ["paypal.com", "paypal.me"]
        patterns[.venmo] = ["venmo.com"]
        patterns[.cashapp] = ["cash.app", "cash.me"]
        patterns[.zelle] = ["zellepay.com"]
        patterns[.stripe] = ["stripe.com"]
        patterns[.square] = ["square.com", "squareup.com"]
        patterns[.alipay] = ["alipay.com", "intl.alipay.com"]
        patterns[.paytm] = ["paytm.com"]
        patterns[.klarna] = ["klarna.com"]
        patterns[.afterpay] = ["afterpay.com"]
        patterns[.affirm] = ["affirm.com"]
        patterns[.chime] = ["chime.com"]
        patterns[.revolut] = ["revolut.com"]
        patterns[.wise] = ["wise.com", "transferwise.com"]
        patterns[.robinhood] = ["robinhood.com"]
        patterns[.etoro] = ["etoro.com"]
        patterns[.webull] = ["webull.com"]
        patterns[.coinbase] = ["coinbase.com"]
        patterns[.binance] = ["binance.com", "binance.us"]
        patterns[.kraken] = ["kraken.com"]
        patterns[.metamask] = ["metamask.io"]
        patterns[.cryptoDotCom] = ["crypto.com"]
        
        // Dating
        patterns[.tinder] = ["tinder.com", "gotinder.com"]
        patterns[.bumble] = ["bumble.com"]
        patterns[.hinge] = ["hinge.co"]
        patterns[.match] = ["match.com"]
        patterns[.okcupid] = ["okcupid.com"]
        patterns[.plentyoffish] = ["pof.com", "plentyoffish.com"]
        patterns[.eharmony] = ["eharmony.com"]
        patterns[.coffeeMeetsBagel] = ["coffeemeetsbagel.com"]
        patterns[.happn] = ["happn.com"]
        patterns[.badoo] = ["badoo.com"]
        patterns[.grindr] = ["grindr.com"]
        patterns[.her] = ["weareher.com"]
        patterns[.feeld] = ["feeld.co"]
        
        // Cloud Storage
        patterns[.dropbox] = ["dropbox.com", "db.tt", "dropboxusercontent.com"]
        patterns[.googleDrive] = ["drive.google.com", "docs.google.com", "sheets.google.com", "slides.google.com"]
        patterns[.onedrive] = ["onedrive.com", "1drv.ms", "onedrive.live.com"]
        patterns[.box] = ["box.com", "app.box.com"]
        patterns[.icloud] = ["icloud.com"]
        patterns[.mega] = ["mega.nz", "mega.io", "mega.co.nz"]
        patterns[.pcloud] = ["pcloud.com", "pc.cd"]
        patterns[.sync] = ["sync.com"]
        patterns[.mediafire] = ["mediafire.com"]
        patterns[.wetransfer] = ["wetransfer.com", "we.tl"]
        
        // News/Publishing
        patterns[.medium] = ["medium.com", "link.medium.com"]
        patterns[.substack] = ["substack.com"]
        patterns[.wordpress] = ["wordpress.com", "wp.com"]
        patterns[.blogger] = ["blogger.com", "blogspot.com"]
        patterns[.ghost] = ["ghost.io", "ghost.org"]
        patterns[.mirror] = ["mirror.xyz"]
        patterns[.revue] = ["getrevue.co"]
        patterns[.convertkit] = ["convertkit.com"]
        patterns[.beehiiv] = ["beehiiv.com"]
        patterns[.hashnode] = ["hashnode.com", "hashnode.dev"]
        patterns[.devto] = ["dev.to"]
        
        // E-Learning
        patterns[.udemy] = ["udemy.com"]
        patterns[.coursera] = ["coursera.org"]
        patterns[.edx] = ["edx.org"]
        patterns[.skillshare] = ["skillshare.com"]
        patterns[.teachable] = ["teachable.com"]
        patterns[.thinkific] = ["thinkific.com"]
        patterns[.kajabi] = ["kajabi.com"]
        patterns[.linkedinLearning] = ["learning.linkedin.com"]
        patterns[.khanAcademy] = ["khanacademy.org"]
        patterns[.udacity] = ["udacity.com"]
        patterns[.pluralsight] = ["pluralsight.com"]
        patterns[.masterclass] = ["masterclass.com"]
        patterns[.brilliantorg] = ["brilliant.org"]
        
        // Web3/Crypto
        patterns[.opensea] = ["opensea.io"]
        patterns[.rarible] = ["rarible.com"]
        patterns[.foundation] = ["foundation.app"]
        patterns[.superrare] = ["superrare.com"]
        patterns[.zora] = ["zora.co"]
        patterns[.lensProtocol] = ["lens.xyz", "lens.dev"]
        patterns[.farcaster] = ["farcaster.xyz", "warpcast.com"]
        patterns[.decentraland] = ["decentraland.org"]
        patterns[.cryptoVoxels] = ["cryptovoxels.com"]
        patterns[.sandbox] = ["sandbox.game"]
        patterns[.axieInfinity] = ["axieinfinity.com"]
        
        // Video Conferencing
        patterns[.zoom] = ["zoom.us", "zoom.com", "zoomgov.com"]
        patterns[.teams] = ["teams.microsoft.com", "teams.live.com"]
        patterns[.googleMeet] = ["meet.google.com"]
        patterns[.skype] = ["skype.com", "skype.co"]
        patterns[.webex] = ["webex.com"]
        patterns[.whereby] = ["whereby.com"]
        patterns[.jitsi] = ["meet.jit.si", "jitsi.org"]
        patterns[.gotomeeting] = ["gotomeeting.com"]
        patterns[.bluejeans] = ["bluejeans.com"]
        
        // Maps
        patterns[.googleMaps] = ["maps.google.com", "goo.gl/maps"]
        patterns[.appleMaps] = ["maps.apple.com"]
        patterns[.waze] = ["waze.com"]
        patterns[.openstreetmap] = ["openstreetmap.org"]
        patterns[.mapbox] = ["mapbox.com"]
        patterns[.hereWeGo] = ["here.com", "wego.here.com"]
        patterns[.citymapper] = ["citymapper.com"]
        
        // Food Delivery
        patterns[.ubereats] = ["ubereats.com"]
        patterns[.doordash] = ["doordash.com"]
        patterns[.grubhub] = ["grubhub.com"]
        patterns[.postmates] = ["postmates.com"]
        patterns[.instacart] = ["instacart.com"]
        patterns[.deliveroo] = ["deliveroo.com", "deliveroo.co.uk"]
        patterns[.justeat] = ["just-eat.com", "justeat.com"]
        patterns[.seamless] = ["seamless.com"]
        
        // Travel
        patterns[.airbnb] = ["airbnb.com"]
        patterns[.booking] = ["booking.com"]
        patterns[.expedia] = ["expedia.com"]
        patterns[.tripadvisor] = ["tripadvisor.com"]
        patterns[.kayak] = ["kayak.com"]
        patterns[.hotels] = ["hotels.com"]
        patterns[.vrbo] = ["vrbo.com"]
        patterns[.agoda] = ["agoda.com"]
        
        // Productivity
        patterns[.notion] = ["notion.so", "notion.site"]
        patterns[.airtable] = ["airtable.com"]
        patterns[.trello] = ["trello.com"]
        patterns[.miro] = ["miro.com"]
        patterns[.canva] = ["canva.com", "canva.link"]
        patterns[.linktree] = ["linktr.ee", "linktree.com"]
        patterns[.carrd] = ["carrd.co"]
        patterns[.asana] = ["asana.com"]
        patterns[.monday] = ["monday.com"]
        patterns[.clickup] = ["clickup.com"]
        patterns[.jira] = ["atlassian.net"]
        
        // Subscription/Creator
        patterns[.onlyfans] = ["onlyfans.com"]
        patterns[.patreon] = ["patreon.com"]
        patterns[.fansly] = ["fansly.com"]
        patterns[.kofi] = ["ko-fi.com"]
        patterns[.buymeacoffee] = ["buymeacoffee.com"]
        patterns[.gumroad] = ["gumroad.com"]
        patterns[.subscribestar] = ["subscribestar.com", "subscribestar.adult"]
        
        // Other
        patterns[.wikipedia] = ["wikipedia.org"]
        
        return patterns
    }()
    
    /// Special subdomain checks that must be evaluated before general domain patterns
    private static let specialSubdomainChecks: [(domain: String, platform: Platform)] = [
        // YouTube family
        ("music.youtube.com", .youtubeMusic),
        ("studio.youtube.com", .youtubeStudio),
        ("gaming.youtube.com", .youtubeGaming),
        
        // Amazon variants
        ("music.amazon.com", .amazonMusic),
        ("music.amazon.co.uk", .amazonMusic),
        ("music.amazon.de", .amazonMusic),
        ("music.amazon.fr", .amazonMusic),
        ("music.amazon.it", .amazonMusic),
        ("music.amazon.es", .amazonMusic),
        ("music.amazon.ca", .amazonMusic),
        ("music.amazon.co.jp", .amazonMusic),
        
        // Learning platforms
        ("learning.linkedin.com", .linkedinLearning),
        
        // Facebook variants
        ("business.facebook.com", .facebook),
        ("developers.facebook.com", .facebook),
        ("gaming.fb.com", .facebookGaming),
        ("fb.gg", .facebookGaming),
        
        // Google services
        ("meet.google.com", .googleMeet),
        ("drive.google.com", .googleDrive),
        ("docs.google.com", .googleDrive),
        ("sheets.google.com", .googleDrive),
        ("slides.google.com", .googleDrive),
        ("forms.google.com", .googleDrive),
        ("sites.google.com", .googleDrive),
        ("maps.google.com", .googleMaps),
        ("podcasts.google.com", .googlePodcasts),
        
        // Microsoft services
        ("teams.microsoft.com", .teams),
        ("teams.live.com", .teams),
        ("onedrive.live.com", .onedrive),
        
        // Apple services
        ("podcasts.apple.com", .applePodcasts),
        ("music.apple.com", .appleMusic),
        ("maps.apple.com", .appleMaps),
        ("itunes.apple.com", .appleMusic), // Legacy but still used
        
        // Spotify variants
        ("open.spotify.com", .spotify),
        ("play.spotify.com", .spotify),
        ("podcasters.spotify.com", .podcastsSpotify),
        
        // Twitch variants
        ("clips.twitch.tv", .twitch),
        ("m.twitch.tv", .twitch),
        ("player.twitch.tv", .twitch),
        
        // GitHub variants
        ("gist.github.com", .github),
        ("raw.githubusercontent.com", .github),
        
        // WeChat/QQ
        ("weixin.qq.com", .wechat),
        ("im.qq.com", .qq),
        
        // Reddit variants
        ("old.reddit.com", .reddit),
        ("np.reddit.com", .reddit),
        ("i.reddit.com", .reddit),
        
        // SoundCloud variants
        ("on.soundcloud.com", .soundcloud),
        ("m.soundcloud.com", .soundcloud),
        
        // Other platforms
        ("player.vimeo.com", .vimeo),
        ("app.slack.com", .slack),
        ("web.whatsapp.com", .whatsapp),
        ("chat.whatsapp.com", .whatsapp),
        ("api.whatsapp.com", .whatsapp),
        ("app.element.io", .element),
        ("warpcast.com", .farcaster),
        ("intl.alipay.com", .alipay),
        ("binance.us", .binance),
        ("app.box.com", .box)
    ]
    
    /// Platforms that should be skipped in the main pattern loop (handled by special checks)
    private static let skipPlatforms: Set<Platform> = [
        .youtubeMusic, .youtubeStudio, .youtubeGaming,
        .linkedinLearning, .wechat, .amazonMusic, .podcastsSpotify,
        .facebookGaming, .googleMeet, .googleDrive, .googleMaps, .googlePodcasts,
        .teams, .applePodcasts, .appleMusic, .appleMaps
    ]
    
    /// Platforms that use custom subdomains (*.platform.com pattern)
    private static let customSubdomainPatterns: [(Platform, String)] = [
        (.bandcamp, "bandcamp.com"),
        (.shopify, ".myshopify.com"),
        (.podbean, ".podbean.com"),
        (.buzzsprout, ".buzzsprout.com"),
        (.substack, ".substack.com"),
        (.medium, ".medium.com"),
        (.wordpress, ".wordpress.com"),
        (.blogger, ".blogspot.com"),
        (.ghost, ".ghost.io"),
        (.notion, ".notion.site"),
        (.jira, ".atlassian.net"),
        (.carrd, ".carrd.co"),
        (.hashnode, ".hashnode.dev"),
        (.vercel, ".vercel.app"),  // If you add Vercel
        (.netlify, ".netlify.app"), // If you add Netlify
        (.github, ".github.io"),     // GitHub Pages
        (.gitlab, ".gitlab.io")      // GitLab Pages
    ]
    
    // MARK: - Initialization
    
    /// Private initializer to prevent instantiation
    private init() {}
    
    // MARK: - Public Methods
    
    /// Validates if a string is a valid URL
    /// - Parameter string: The string to validate
    /// - Returns: True if the string is a valid URL
    public static func isValid(_ string: String) -> Bool {
        guard !string.isEmpty else { return false }
        
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        // Check for email-like patterns (contains @ but no scheme)
        if trimmed.contains("@") && !trimmed.contains("://") {
            return false
        }
        
        // Check for malformed scheme (starts with ://)
        if trimmed.hasPrefix("://") {
            return false
        }
        
        // Check for scheme without host (like http://:8080)
        // But allow file:// URLs which don't have traditional hosts
        if trimmed.contains("://") && !trimmed.hasPrefix("file://") {
            let parts = trimmed.components(separatedBy: "://")
            if parts.count == 2 {
                let afterScheme = parts[1]
                // Check if it starts with : (port) without a host
                if afterScheme.hasPrefix(":") {
                    return false
                }
                // Check if it's empty or only has a path
                if afterScheme.isEmpty || afterScheme.hasPrefix("/") {
                    return false
                }
            }
        }
        
        // Single word without dots or scheme (except localhost)
        if !trimmed.contains(".") && !trimmed.contains("://") {
            // Allow localhost and localhost with port
            if trimmed != "localhost" && !trimmed.hasPrefix("localhost:") {
                return false
            }
        }
        
        // First try as-is
        if let url = URL(string: trimmed) {
            // If it has a scheme, validate normally
            if let scheme = url.scheme {
                // Special handling for file URLs
                if scheme == "file" {
                    // File URLs are valid if they can be created
                    return true
                }
                // For HTTP(S) URLs, ensure there's a host
                if scheme == "http" || scheme == "https" {
                    return url.host != nil && !url.host!.isEmpty
                }
                // For other schemes with "://", ensure there's content after
                if trimmed.contains("://") {
                    let afterScheme = trimmed.components(separatedBy: "://").last ?? ""
                    // Allow if there's content and it's not just a port
                    return !afterScheme.isEmpty && !afterScheme.hasPrefix(":")
                }
                return true
            }
        }
        
        // If no scheme, try adding https:// and see if it becomes valid
        if !trimmed.contains("://") {
            // Check if it looks like a domain/URL without scheme
            let withHTTPS = "https://\(trimmed)"
            if let url = URL(string: withHTTPS),
               url.host != nil {
                return true
            }
        }
        
        return false
    }
    
    /// Normalizes a URL string by adding scheme if missing
    /// - Parameter string: The URL string to normalize
    /// - Returns: Normalized URL string with scheme, or original if already valid
    public static func normalize(_ string: String) -> String {
        guard !string.isEmpty else { return string }
        
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If it already has a scheme, return as-is
        if trimmed.contains("://") {
            return trimmed
        }
        
        // If it looks like a URL without scheme, add https://
        if !trimmed.contains(" ") && (trimmed.contains(".") || trimmed.contains("localhost")) {
            return "https://\(trimmed)"
        }
        
        return trimmed
    }
    
    /// Detects the platform from a URL string
    /// - Parameter urlString: The URL string to analyze
    /// - Returns: The detected platform or .unknown
    public static func detectPlatform(from urlString: String) -> Platform {
        let normalized = normalize(urlString)
        
        guard let url = URL(string: normalized),
              let host = url.host?.lowercased() else {
            return .unknown
        }
        
        let cleanHost = host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
        let path = url.path.lowercased()
        
        // Check special subdomains first
        for (domain, platform) in specialSubdomainChecks {
            if cleanHost == domain {
                return platform
            }
        }
        
        // Path-based special cases
        if (cleanHost == "youtube.com" || cleanHost == "m.youtube.com") && path.contains("/shorts/") {
            return .youtubeShorts
        }
        
        if (cleanHost == "instagram.com" || cleanHost == "instagr.am") && path.contains("/reel/") {
            return .instagramReels
        }
        
        // Check against platform patterns
        for (platform, domains) in platformPatterns {
            if skipPlatforms.contains(platform) {
                continue
            }
            
            for domain in domains {
                if cleanHost == domain || cleanHost.hasSuffix(".\(domain)") {
                    return platform
                }
            }
        }
        
        // Check custom subdomain patterns
        for (platform, pattern) in customSubdomainPatterns {
            if cleanHost.contains(pattern) {
                return platform
            }
        }
        
        return .unknown
    }
    
    /// Gets the category for a platform using modern Swift patterns
    /// - Parameter platform: The platform to categorize
    /// - Returns: The platform's category
    public static func category(for platform: Platform) -> PlatformCategory {
        switch platform {
            // Video Platforms (but not YouTube Music)
        case .youtube, .youtubeShorts, .vimeo, .dailymotion, .twitch, .kick,
                .veoh, .metacafe, .youtubeStudio, .youtubeGaming:
            return .video
            
            // Audio Platforms (INCLUDING YouTube Music)
        case .spotify, .appleMusic, .applePodcasts, .soundcloud, .bandcamp, .deezer, .tidal,
                .amazonMusic, .youtubeMusic, .pandora, .audiomack, .qobuz, .mixcloud, .beatport,
                .napster, .iheartradio, .tunein, .anghami, .gaana, .jiosaavn, .lastfm, .genius,
                .anchor, .pocketCasts, .overcast, .castbox, .googlePodcasts, .stitcher,
                .podbean, .buzzsprout, .podcastsSpotify, .podcastAddict, .castro:
            return .audio
            
            // Alternative Video Platforms
        case .rumble, .bitchute, .odysee, .peertube, .dtube, .brighteon, .banned,
                .rokfin, .floatplane, .nebula, .lbry:
            return .alternative
            
            // Short-form Video
        case .tiktok, .instagramReels, .douyin, .kuaishou, .likee, .triller, .byte, .clash:
            return .video
            
            // Social Media
        case .facebook, .twitter, .instagram, .linkedin, .reddit, .pinterest, .tumblr,
                .threads, .snapchat, .vero, .ello:
            return .social
            
            // Alternative Social
        case .mastodon, .bluesky, .truthSocial, .gab, .parler, .mewe, .gettr, .minds, .locals, .diaspora:
            return .alternative
            
            // Asian/Regional Platforms
        case .weibo, .wechat, .qq, .xiaohongshu, .bilibili, .youku, .niconico, .kakaotalk, .line, .zalo, .vk:
            return .regional
            
            // Messaging
        case .whatsapp, .telegram, .discord, .slack, .signal, .messenger, .viber, .element, .matrix,
                .threema, .wire, .session, .keybase:
            return .messaging
            
            // Live Streaming
        case .twitchLive, .facebookGaming, .dlive, .caffeine, .trovo, .picarto, .younow, .bigoLive,
                .streamyard, .streamlabs, .restream, .obsLive:
            return .streaming
            
            // Developer
        case .github, .gitlab, .bitbucket, .stackoverflow, .codepen, .codesandbox, .replit,
                .figma, .dribbble, .behance, .angellist, .producthunt, .polywork, .wellfound,
                .glitch, .kaggle, .vercel, .netlify:
            return .developer
            
            // E-commerce
        case .amazon, .ebay, .etsy, .shopify, .alibaba, .aliexpress, .mercari, .poshmark, .depop,
                .walmart, .target, .bestbuy, .wish, .shein, .wayfair:
            return .ecommerce
            
            // Gaming
        case .steam, .epicGames, .battlenet, .origin, .uplay, .gog, .itchIo, .roblox, .minecraft,
                .fortnite, .leagueOfLegends, .valorant, .xbox, .playstation, .nintendo:
            return .gaming
            
            // Financial (UPDATED with new platforms)
        case .paypal, .venmo, .cashapp, .zelle, .stripe, .square, .coinbase, .binance, .kraken,
                .robinhood, .etoro, .revolut, .wise, .klarna, .afterpay, .affirm, .chime,
                .metamask, .cryptoDotCom, .webull, .alipay, .paytm:
            return .financial
            
            // Dating
        case .tinder, .bumble, .hinge, .match, .okcupid, .plentyoffish, .eharmony,
                .coffeeMeetsBagel, .happn, .badoo, .grindr, .her, .feeld:
            return .dating
            
            // Cloud Storage
        case .dropbox, .googleDrive, .onedrive, .box, .icloud, .mega, .pcloud, .sync,
                .mediafire, .wetransfer:
            return .cloud
            
            // News/Publishing
        case .medium, .substack, .wordpress, .blogger, .ghost, .mirror, .revue,
                .convertkit, .beehiiv, .hashnode, .devto:
            return .news
            
            // E-Learning
        case .udemy, .coursera, .edx, .skillshare, .teachable, .thinkific, .kajabi,
                .linkedinLearning, .khanAcademy, .udacity, .pluralsight, .masterclass, .brilliantorg:
            return .learning
            
            // Web3/Crypto
        case .opensea, .rarible, .foundation, .superrare, .zora, .lensProtocol,
                .farcaster, .decentraland, .cryptoVoxels, .sandbox, .axieInfinity:
            return .web3
            
            // Video Conferencing
        case .zoom, .teams, .googleMeet, .skype, .webex, .whereby, .jitsi, .gotomeeting, .bluejeans:
            return .streaming
            
            // Maps
        case .googleMaps, .appleMaps, .waze, .openstreetmap, .mapbox, .hereWeGo, .citymapper:
            return .maps
            
            // Food Delivery
        case .ubereats, .doordash, .grubhub, .postmates, .instacart, .deliveroo, .justeat, .seamless:
            return .food
            
            // Travel
        case .airbnb, .booking, .expedia, .tripadvisor, .kayak, .hotels, .vrbo, .agoda:
            return .travel
            
            // Productivity
        case .notion, .airtable, .trello, .miro, .canva, .wikipedia, .linktree, .carrd,
                .asana, .monday, .clickup, .jira:
            return .productivity
            
            // Subscription/Creator
        case .onlyfans, .patreon, .fansly, .kofi, .buymeacoffee, .gumroad, .subscribestar:
            return .subscription
            
        case .unknown:
            return .unknown
        }
    }
    
    /// Detects the media type from a URL's file extension using UTType and manual fallbacks
    ///
    /// This method first checks against known problematic extensions that UTType may not recognize,
    /// then falls back to UTType for standard format detection.
    ///
    /// - Parameter urlString: The URL string to analyze
    /// - Returns: The detected media type (.image, .video, .audio, etc.) or .unknown if unrecognized
    ///
    /// - Note: The method normalizes the URL before processing and handles URLs without schemes
    ///
    /// Example:
    /// ```swift
    /// let mediaType = URLValidator.detectMediaType(from: "example.com/video.mkv")
    /// // Returns: .video
    /// ```
    public static func detectMediaType(from urlString: String) -> MediaType {
        // Normalize the URL first
        let normalized = normalize(urlString)
        
        guard let url = URL(string: normalized) else { return .unknown }
        
        let pathExtension = url.pathExtension.lowercased()
        guard !pathExtension.isEmpty else { return .unknown }
        
        // Check manual lists first for known problematic formats
        // Using Set for O(1) lookup performance
        if audioExtensions.contains(pathExtension) {
            return .audio
        }
        
        if videoExtensions.contains(pathExtension) {
            return .video
        }
        
        // Use UTType for standard format detection
        // This handles most common formats that are properly registered with the system
        guard let utType = UTType(filenameExtension: pathExtension) else {
            return .unknown
        }
        
        // Check conformance to various types in order of likelihood
        if utType.conforms(to: .image) { return .image }
        if utType.conforms(to: .movie) || utType.conforms(to: .video) { return .video }
        if utType.conforms(to: .audio) { return .audio }
        if utType.conforms(to: .pdf) || utType.conforms(to: .text) || utType.conforms(to: .rtf) { return .document }
        if utType.conforms(to: .archive) { return .archive }
        if utType.conforms(to: .sourceCode) { return .code }
        if utType.conforms(to: .data) || utType.conforms(to: .database) { return .data }
        if utType.conforms(to: .executable) || utType.conforms(to: .application) { return .executable }
        if utType.conforms(to: .font) { return .font }
        if utType.conforms(to: .threeDContent) { return .model3d }
        
        return .unknown
    }
    
    /// Analyzes a URL and returns comprehensive information
    /// - Parameter urlString: The URL string to analyze
    /// - Returns: A URLAnalysis object with detailed information
    public static func analyze(_ urlString: String) -> URLAnalysis {
        var analysis = URLAnalysis(originalURL: urlString)
        
        // Validate original URL
        analysis.isValid = isValid(urlString)
        guard analysis.isValid else {
            return analysis
        }
        
        // Normalize URL for analysis
        let normalized = normalize(urlString)
        guard let url = URL(string: normalized) else {
            analysis.isValid = false
            return analysis
        }
        
        analysis.url = url
        
        // Basic properties
        analysis.scheme = url.scheme
        analysis.host = url.host
        analysis.path = url.path.isEmpty ? nil : url.path
        analysis.query = url.query
        analysis.fragment = url.fragment
        analysis.port = url.port
        
        // Security
        analysis.isHTTPS = url.scheme == "https"
        analysis.isHTTP = url.scheme == "http"
        analysis.isFileURL = url.isFileURL
        
        // Platform detection
        analysis.platform = detectPlatform(from: urlString)
        if analysis.platform != Platform.unknown {
            analysis.platformCategory = category(for: analysis.platform)
        }
        
        // Media type detection
        if let pathExtension = url.pathExtension.nilIfEmpty {
            analysis.fileExtension = pathExtension.lowercased()
            analysis.mediaType = detectMediaType(from: urlString)
            
            // UTType information
            if let utType = UTType(filenameExtension: pathExtension) {
                analysis.utType = utType
                analysis.mimeType = utType.preferredMIMEType
                analysis.fileTypeDescription = utType.localizedDescription
            }
        }
        
        // Extract special IDs
        analysis.extractedIDs = extractIDs(from: url, platform: analysis.platform)
        
        return analysis
    }
    
    // MARK: - Private Methods
    
    /// Main ID extraction method that delegates to platform-specific extractors
    /// - Parameters:
    ///   - url: The URL to analyze
    ///   - platform: The detected platform
    /// - Returns: Dictionary of extracted IDs with descriptive keys
    ///
    /// Supported platforms:
    /// - YouTube (video IDs)
    /// - Twitter/X (tweet IDs)
    /// - Instagram (post IDs)
    /// - TikTok (video IDs)
    /// - Spotify (track/album/playlist IDs)
    /// - Reddit (post IDs)
    /// - GitHub (owner/repo/PR/issue)
    /// - LinkedIn (activity IDs)
    /// - Vimeo (video IDs)
    /// - Facebook (post/video IDs)
    /// - Twitch (clip IDs)
    /// - SoundCloud (artist/track)
    /// - Medium (user/article IDs)
    private static func extractIDs(from url: URL, platform: Platform) -> [String: String] {
        var ids: [String: String] = [:]
        let path = url.path
        let host = url.host?.lowercased() ?? ""
        
        switch platform {
        case .youtube, .youtubeMusic, .youtubeShorts:
            if let videoID = extractYouTubeVideoID(from: url, host: host) {
                ids["youtube_video_id"] = videoID
            }
            
        case .twitter:
            if let tweetID = extractTwitterID(from: path) {
                ids["tweet_id"] = tweetID
            }
            
        case .instagram, .instagramReels:
            if let postID = extractInstagramID(from: path) {
                ids["instagram_post_id"] = postID
            }
            
        case .tiktok:
            if let videoID = extractTikTokID(from: path) {
                ids["tiktok_video_id"] = videoID
            }
            
        case .spotify:
            let spotifyIDs = extractSpotifyIDs(from: path)
            ids.merge(spotifyIDs) { _, new in new }
            
        case .reddit:
            if let postID = extractRedditID(from: path) {
                ids["reddit_post_id"] = postID
            }
            
        case .github:
            let githubIDs = extractGitHubIDs(from: path)
            ids.merge(githubIDs) { _, new in new }
            
        case .linkedin:
            if let activityID = extractLinkedInID(from: path) {
                ids["linkedin_activity_id"] = activityID
            }
            
        case .vimeo:
            if let videoID = extractVimeoID(from: path) {
                ids["vimeo_video_id"] = videoID
            }
            
        case .facebook:
            let facebookIDs = extractFacebookIDs(from: url)
            ids.merge(facebookIDs) { _, new in new }
            
        case .twitch:
            if let clipID = extractTwitchClipID(from: url, host: host) {
                ids["twitch_clip_id"] = clipID
            }
            
        case .soundcloud:
            let soundcloudIDs = extractSoundCloudIDs(from: path)
            ids.merge(soundcloudIDs) { _, new in new }
            
        case .medium:
            let mediumIDs = extractMediumIDs(from: path)
            ids.merge(mediumIDs) { _, new in new }
            
        default:
            break
        }
        
        return ids
    }
    
    /// Extracts LinkedIn activity ID from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: The LinkedIn activity ID if found, nil otherwise
    ///
    /// Example:
    /// - Input: "/posts/username_activity-7123456789"
    /// - Output: "7123456789"
    private static func extractLinkedInID(from path: String) -> String? {
        guard path.contains("/posts/") else { return nil }
        
        let components = path.split(separator: "/")
        guard let postsIndex = components.firstIndex(of: "posts"),
              postsIndex + 1 < components.count else { return nil }
        
        let postPart = String(components[postsIndex + 1])
        return postPart.split(separator: "-").last.map(String.init)
    }
    
    /// Extracts Vimeo video ID from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: The Vimeo video ID if found, nil otherwise
    ///
    /// Example:
    /// - Input: "/123456789"
    /// - Output: "123456789"
    private static func extractVimeoID(from path: String) -> String? {
        let components = path.split(separator: "/")
        guard let videoID = components.last,
              videoID.allSatisfy({ $0.isNumber }) else { return nil }
        return String(videoID)
    }
    
    /// Extracts Facebook post and video IDs from a URL
    /// - Parameter url: The URL to analyze
    /// - Returns: Dictionary containing facebook_post_id and/or facebook_video_id
    ///
    /// Examples:
    /// - Post: "facebook.com/username/posts/123456789" → ["facebook_post_id": "123456789"]
    /// - Video: "facebook.com/watch/?v=987654321" → ["facebook_video_id": "987654321"]
    private static func extractFacebookIDs(from url: URL) -> [String: String] {
        var ids: [String: String] = [:]
        let path = url.path
        
        // Facebook post: facebook.com/username/posts/123456789
        if path.contains("/posts/") {
            let components = path.split(separator: "/")
            if let postsIndex = components.firstIndex(of: "posts"),
               postsIndex + 1 < components.count {
                ids["facebook_post_id"] = String(components[postsIndex + 1])
            }
        }
        
        // Facebook video: facebook.com/watch/?v=123456789
        if let query = url.query {
            let params = query.split(separator: "&")
            for param in params {
                let parts = param.split(separator: "=", maxSplits: 1)
                if parts.count == 2 && parts[0] == "v" {
                    ids["facebook_video_id"] = String(parts[1])
                    break
                }
            }
        }
        
        return ids
    }
    
    /// Extracts Twitch clip ID from a URL
    /// - Parameters:
    ///   - url: The URL to analyze
    ///   - host: The lowercase host of the URL
    /// - Returns: The Twitch clip ID if found, nil otherwise
    ///
    /// Examples:
    /// - Direct: "clips.twitch.tv/ClipName" → "ClipName"
    /// - Channel: "twitch.tv/username/clip/ClipName" → "ClipName"
    private static func extractTwitchClipID(from url: URL, host: String) -> String? {
        let path = url.path
        
        // Twitch clip: clips.twitch.tv/ClipName
        if host == "clips.twitch.tv" {
            let clipID = path.dropFirst() // Remove leading /
            return clipID.isEmpty ? nil : String(clipID)
        }
        
        // Or: twitch.tv/username/clip/ClipName
        if path.contains("/clip/") {
            let components = path.split(separator: "/")
            if let clipIndex = components.firstIndex(of: "clip"),
               clipIndex + 1 < components.count {
                return String(components[clipIndex + 1])
            }
        }
        
        return nil
    }
    
    /// Extracts SoundCloud artist and track information from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing soundcloud_artist and soundcloud_track if found
    ///
    /// Example:
    /// - Input: "/artist-name/track-name"
    /// - Output: ["soundcloud_artist": "artist-name", "soundcloud_track": "track-name"]
    private static func extractSoundCloudIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        // SoundCloud track: soundcloud.com/artist/track-name
        let components = path.split(separator: "/").filter { !$0.isEmpty }
        if components.count >= 2 {
            ids["soundcloud_artist"] = String(components[0])
            ids["soundcloud_track"] = String(components[1])
        }
        
        return ids
    }
    
    /// Extracts Medium user and article IDs from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing medium_user and/or medium_article_id
    ///
    /// Example:
    /// - Input: "/@username/article-title-abc123def456"
    /// - Output: ["medium_user": "username", "medium_article_id": "abc123def456"]
    ///
    /// - Note: Medium article IDs are typically 12+ characters and appear after the last dash in the URL
    private static func extractMediumIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        // Medium article: medium.com/@username/article-title-abc123
        guard path.contains("@") else { return ids }
        
        let components = path.split(separator: "/")
        
        // Extract username
        if let userComponent = components.first(where: { $0.hasPrefix("@") }) {
            ids["medium_user"] = String(userComponent.dropFirst()) // Remove @
        }
        
        // Extract article ID (last component often has article ID at the end)
        if let lastComponent = components.last,
           let dashIndex = lastComponent.lastIndex(of: "-") {
            let articleID = lastComponent[lastComponent.index(after: dashIndex)...]
            if articleID.count > 10 { // Medium IDs are usually long
                ids["medium_article_id"] = String(articleID)
            }
        }
        
        return ids
    }
    
    /// Extracts YouTube video ID from various YouTube URL formats
    /// - Parameters:
    ///   - url: The URL to analyze
    ///   - host: The lowercase host of the URL
    /// - Returns: The YouTube video ID if found, nil otherwise
    ///
    /// Supported formats:
    /// - youtu.be/VIDEO_ID (shortened URLs)
    /// - youtube.com/watch?v=VIDEO_ID (standard watch URLs)
    /// - youtube.com/shorts/VIDEO_ID (YouTube Shorts)
    ///
    /// Example:
    /// - Input: "https://youtu.be/dQw4w9WgXcQ"
    /// - Output: "dQw4w9WgXcQ"
    private static func extractYouTubeVideoID(from url: URL, host: String) -> String? {
        if host == "youtu.be" {
            // Format: youtu.be/VIDEO_ID
            let videoId = url.path.dropFirst() // Remove leading /
            return videoId.isEmpty ? nil : String(videoId)
        } else if let query = url.query {
            // Format: youtube.com/watch?v=VIDEO_ID
            let params = query.split(separator: "&")
            for param in params {
                let parts = param.split(separator: "=", maxSplits: 1)
                if parts.count == 2 && parts[0] == "v" {
                    return String(parts[1])
                }
            }
        } else if url.path.contains("/shorts/") {
            // Format: youtube.com/shorts/VIDEO_ID
            let components = url.path.split(separator: "/")
            if let shortsIndex = components.firstIndex(of: "shorts"),
               shortsIndex + 1 < components.count {
                return String(components[shortsIndex + 1])
            }
        }
        return nil
    }
    
    /// Extracts Twitter/X tweet ID from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: The tweet ID if found, nil otherwise
    ///
    /// Example:
    /// - Input: "/elonmusk/status/1234567890123456789"
    /// - Output: "1234567890123456789"
    ///
    /// - Note: Works for both twitter.com and x.com domains
    private static func extractTwitterID(from path: String) -> String? {
        let components = path.split(separator: "/")
        if let statusIndex = components.firstIndex(of: "status"),
           statusIndex + 1 < components.count {
            return String(components[statusIndex + 1])
        }
        return nil
    }
    
    /// Extracts Instagram post or reel ID from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: The Instagram post/reel ID if found, nil otherwise
    ///
    /// Supported formats:
    /// - instagram.com/p/POST_ID (posts)
    /// - instagram.com/reel/REEL_ID (reels)
    ///
    /// Example:
    /// - Input: "/p/CyTPsXYMzTj/"
    /// - Output: "CyTPsXYMzTj"
    private static func extractInstagramID(from path: String) -> String? {
        let components = path.split(separator: "/")
        if let postIndex = components.firstIndex(where: { $0 == "p" || $0 == "reel" }),
           postIndex + 1 < components.count {
            return String(components[postIndex + 1])
        }
        return nil
    }
    
    /// Extracts TikTok video ID from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: The TikTok video ID if found, nil otherwise
    ///
    /// Example:
    /// - Input: "/@username/video/7156932021247864110"
    /// - Output: "7156932021247864110"
    ///
    /// - Note: TikTok video IDs are typically long numeric strings
    private static func extractTikTokID(from path: String) -> String? {
        if let range = path.range(of: "/video/", options: .caseInsensitive) {
            let afterVideo = String(path[range.upperBound...])
            let id = afterVideo
                .components(separatedBy: "/")[0]
                .components(separatedBy: "?")[0]
                .components(separatedBy: "#")[0]
            
            return id.isEmpty ? nil : id
        }
        return nil
    }
    
    /// Extracts Spotify content IDs from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing the Spotify content type and ID
    ///
    /// Supported content types:
    /// - track (songs)
    /// - album (albums)
    /// - playlist (playlists)
    /// - episode (podcast episodes)
    /// - show (podcasts)
    /// - artist (artist profiles)
    ///
    /// Example:
    /// - Input: "/track/4cOdK2wGLETKBW3PvgPWqT"
    /// - Output: ["spotify_track_id": "4cOdK2wGLETKBW3PvgPWqT"]
    private static func extractSpotifyIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        let components = path.split(separator: "/")
        if components.count >= 2 {
            let type = String(components[components.count - 2])
            let id = String(components[components.count - 1])
            if ["track", "album", "playlist", "episode", "show", "artist"].contains(type) {
                ids["spotify_\(type)_id"] = id
            }
        }
        return ids
    }
    
    /// Extracts Reddit post ID from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: The Reddit post ID if found, nil otherwise
    ///
    /// Example:
    /// - Input: "/r/swift/comments/abc123/post_title_here/"
    /// - Output: "abc123"
    ///
    /// - Note: Reddit post IDs are typically 5-7 character alphanumeric strings
    private static func extractRedditID(from path: String) -> String? {
        let components = path.split(separator: "/")
        if let commentsIndex = components.firstIndex(of: "comments"),
           commentsIndex + 1 < components.count {
            return String(components[commentsIndex + 1])
        }
        return nil
    }
    
    /// Extracts GitHub repository and issue/PR information from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing github_owner, github_repo, and optionally github_pr_number or github_issue_number
    ///
    /// Supported formats:
    /// - github.com/owner/repo (repository)
    /// - github.com/owner/repo/pull/123 (pull request)
    /// - github.com/owner/repo/issues/456 (issue)
    ///
    /// Example:
    /// - Input: "/apple/swift/pull/12345"
    /// - Output: ["github_owner": "apple", "github_repo": "swift", "github_pr_number": "12345"]
    private static func extractGitHubIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        let components = path.split(separator: "/").map(String.init)
        
        if components.count >= 2 {
            ids["github_owner"] = components[0]
            ids["github_repo"] = components[1]
            
            if components.count >= 4 {
                if components[2] == "pull" {
                    ids["github_pr_number"] = components[3]
                } else if components[2] == "issues" {
                    ids["github_issue_number"] = components[3]
                }
            }
        }
        
        return ids
    }
    
}
