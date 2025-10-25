import NativeRPC from "./native-rpc-h5";
import "./App.css";

type AppInfo = {
  appId: string;
  appName: string;
  appVersion: string;
  systemVersion: string;
};

const callService = async () => {
  const response = await NativeRPC.call<AppInfo>("app.info");
  alert(JSON.stringify(response));
};

function App() {
  return (
    <>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => callService()}>Call RPC Service</button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
    </>
  );
}

export default App;
