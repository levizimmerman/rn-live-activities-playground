import React from 'react';
import {Button, SafeAreaView, NativeModules, View} from 'react-native';

const {TimerWidgetModule} = NativeModules;

const App: React.FC = () => {
  return (
    <SafeAreaView style={{flex: 1, justifyContent: 'center'}}>
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          paddingHorizontal: 48,
        }}>
        <Button
          title="Start Timer"
          onPress={() => {
            TimerWidgetModule.startLiveActivity();
          }}
        />
        <Button
          title="Stop Timer"
          onPress={() => {
            TimerWidgetModule.stopLiveActivity();
          }}
        />
      </View>
    </SafeAreaView>
  );
};

export default App;
