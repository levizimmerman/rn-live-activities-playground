import React from 'react';
import {NativeModules} from 'react-native';

const {TimerWidgetModule} = NativeModules;

const useTimer = () => {
  const [elapsedTimeInMs, setElapsedTimeInMs] = React.useState(0);
  const startTime = React.useRef<number | null>(null);
  const intervalId = React.useRef<NodeJS.Timeout | null>(null);

  const elapsedTimeInSeconds = Math.floor(elapsedTimeInMs / 1000);
  const secondUnits = elapsedTimeInSeconds % 10;
  const secondTens = Math.floor(elapsedTimeInSeconds / 10) % 6;
  const minutes = Math.floor(elapsedTimeInSeconds / 60);
  const value = `${minutes}:${secondTens}${secondUnits}`;

  const play = () => {
    if (intervalId.current) {
      return;
    }

    if (!startTime.current) {
      startTime.current = Date.now();
    }

    TimerWidgetModule.startLiveActivity();

    intervalId.current = setInterval(() => {
      setElapsedTimeInMs(Date.now() - startTime.current!);
    }, 1000);
  };

  const removeInterval = () => {
    if (intervalId.current) {
      clearInterval(intervalId.current);
      intervalId.current = null;
    }
  };

  const reset = () => {
    removeInterval();
    startTime.current = null;
    setElapsedTimeInMs(0);
    TimerWidgetModule.stopLiveActivity();
  };

  return {
    value,
    play,
    reset,
  };
};

export default useTimer;
