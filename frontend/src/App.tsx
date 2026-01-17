import ItemList from "./components/ItemList";
import CreateItem from "./components/CreateItem";
import MovementForm from "./components/MovementForm";
import "./App.css";

function App() {
  return (
    <div className="app">
      <header className="app-header">
        <div>
          <p className="app-eyebrow">Inventory Suite</p>
          <h1 className="app-title">Inventory Management</h1>
          <p className="app-subtitle">
            Create items, record movements, and track stock in one place.
          </p>
        </div>
        <div className="app-pill">Fast • Reliable • Simple</div>
      </header>

      <section className="grid">
        <CreateItem />
        <MovementForm />
      </section>

      <section className="section">
        <ItemList />
      </section>
    </div>
  );
}

export default App;
