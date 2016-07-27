import {
  NativeModules,
} from 'react-native';

const {SegmentAnalytics} = NativeModules;

export default {
  setup: function (configuration: Object) {
    SegmentAnalytics.setup(configuration);
  },

  identify: function (userId: string, traits: Object) {
    SegmentAnalytics.identify(userId, traits);
  },

  track: function (trackText: string, properties: Object) {
    SegmentAnalytics.track(trackText, properties);
  },

  screen: function (screenName: string, properties: Object) {
    SegmentAnalytics.screen(screenName, properties);
  },

  alias: function (aliasId: string) {
    SegmentAnalytics.alias(aliasId);
  }
};
