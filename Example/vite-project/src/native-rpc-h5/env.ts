import { type HybridWindow } from "./global";

class Env {
  private static _platformId: "Android" | "iOS" | "Web" | null = null;
  private static _isAndroid: boolean | null = null;
  private static _isiOS: boolean | null = null;

  private static get win(): HybridWindow {
    return window as HybridWindow;
  }

  static getPlatformId = (): "Android" | "iOS" | "Web" => {
    if (this._platformId === null) {
      if (this.win?.androidBridge) {
        this._platformId = "Android";
      } else if (this.win?.webkit?.messageHandlers?.bridge) {
        this._platformId = "iOS";
      } else {
        this._platformId = "Web";
      }
    }
    return this._platformId;
  };

  static isAndroid = (): boolean => {
    if (this._isAndroid === null) {
      this._isAndroid = !!this.win?.androidBridge;
    }
    return this._isAndroid;
  };

  static isiOS = (): boolean => {
    if (this._isiOS === null) {
      this._isiOS = !!this.win?.webkit?.messageHandlers?.bridge;
    }
    return this._isiOS;
  };
}

export default Env;
