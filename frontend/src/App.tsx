import ItemList from "./components/ItemList";
import CreateItem from "./components/CreateItem";
import MovementForm from "./components/MovementForm";

function App() {
  return (
    <div>
      <h1>Inventory Management</h1>
      <CreateItem />
      <MovementForm />
      <ItemList />
    </div>
  );
}

export default App;
