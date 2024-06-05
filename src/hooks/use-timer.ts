import React from 'react';
import {NativeEventEmitter, NativeModules, NativeModule} from 'react-native';

const {TimerWidgetModule} = NativeModules;

const TimerEventEmitter = new NativeEventEmitter(
  NativeModules.TimerEventEmitter as NativeModule,
);

const useTimer = () => {
  const [elapsedTimeInMs, setElapsedTimeInMs] = React.useState(0);
  const [isPlaying, setIsPlaying] = React.useState(false);
  const startTime = React.useRef<number | null>(null);
  const intervalId = React.useRef<NodeJS.Timeout | null>(null);
  const pausedTime = React.useRef<number | null>(null);

  const elapsedTimeInSeconds = Math.floor(elapsedTimeInMs / 1000);
  const secondUnits = elapsedTimeInSeconds % 10;
  const secondTens = Math.floor(elapsedTimeInSeconds / 10) % 6;
  const minutes = Math.floor(elapsedTimeInSeconds / 60);
  const value = `${minutes}:${secondTens}${secondUnits}`;

  const play = React.useCallback(() => {
    setIsPlaying(true);

    if (intervalId.current) {
      return;
    }

    if (!startTime.current) {
      startTime.current = Date.now();
    }

    if (pausedTime.current) {
      const elapsedSincePaused = Date.now() - pausedTime.current;
      startTime.current = startTime.current! + elapsedSincePaused;
      pausedTime.current = null;
      TimerWidgetModule.resume();
    } else {
      TimerWidgetModule.startLiveActivity(startTime.current / 1000);
    }

    intervalId.current = setInterval(() => {
      setElapsedTimeInMs(Date.now() - startTime.current!);
    }, 32);
  }, []);

  const removeInterval = () => {
    if (intervalId.current) {
      clearInterval(intervalId.current);
      intervalId.current = null;
    }
  };

  const pause = React.useCallback(() => {
    setIsPlaying(false);
    removeInterval();
    if (startTime.current && !pausedTime.current) {
      pausedTime.current = Date.now();
      TimerWidgetModule.pause(pausedTime.current / 1000);
      setElapsedTimeInMs(pausedTime.current! - startTime.current!);
    }
  }, []);

  const reset = React.useCallback(() => {
    setIsPlaying(false);
    removeInterval();
    startTime.current = null;
    pausedTime.current = null;
    setElapsedTimeInMs(0);
    TimerWidgetModule.stopLiveActivity();
  }, []);

  React.useEffect(() => {
    const pauseSub = TimerEventEmitter.addListener('onPause', pause);
    const resumeSub = TimerEventEmitter.addListener('onResume', play);
    const resetSub = TimerEventEmitter.addListener('onReset', reset);

    return () => {
      pauseSub.remove();
      resumeSub.remove();
      resetSub.remove();
    };
  }, [pause, reset, play]);

  return {
    value,
    play,
    pause,
    reset,
    isPlaying,
  };
};

export default useTimer;
