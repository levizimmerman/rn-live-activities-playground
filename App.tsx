import React from 'react';
import {Button, SafeAreaView, View, Text, NativeModules} from 'react-native';
import useTimer from './src/hooks/use-timer';

const {MatchTrackerWidgetModule} = NativeModules;

const App: React.FC = () => {
  const {value, play, reset, pause, isPlaying} = useTimer();

  const startMatch = () => {
    MatchTrackerWidgetModule.startLiveActivity();
  };

  const stopMatch = () => {
    MatchTrackerWidgetModule.stopLiveActivity();
  };

  return (
    <SafeAreaView
      style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
      <View style={{flexDirection: 'row', gap: 12}}>
        <Button title="Start Match" onPress={startMatch} />
        <Button title="Stop Match" onPress={stopMatch} />
      </View>
      <View style={{paddingVertical: 32}}>
        <Text style={{fontSize: 80, fontVariant: ['tabular-nums']}}>
          {value}
        </Text>
      </View>
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          paddingHorizontal: 48,
        }}>
        <View style={{marginRight: 32}}>
          <Button
            title={isPlaying ? 'Pause' : 'Start'}
            onPress={isPlaying ? pause : play}
          />
        </View>
        <Button title="Reset" onPress={reset} />
      </View>
    </SafeAreaView>
  );
};

export default App;
