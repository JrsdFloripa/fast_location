import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Box<String> _historicoBox = Hive.box<String>('historico');
  TextEditingController searchController = TextEditingController();

  List<String> get historico => _historicoBox.values.toList();
  List<String> historicoFiltrado = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filtrarHistorico);
    historicoFiltrado = historico;
  }

  void _filtrarHistorico() {
    setState(() {
      historicoFiltrado = historico.where((endereco) =>
          endereco.toLowerCase().contains(searchController.text.toLowerCase())).toList();
    });
  }

  Future<void> limparHistorico() async {
    await _historicoBox.clear();
    setState(() {
      historicoFiltrado.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Endereços'),
      backgroundColor: Color.fromARGB(255, 13, 121, 88),),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por palavra-chave',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: historicoFiltrado.isNotEmpty
                  ? Scrollbar(
                      child: ListView.builder(
                        itemCount: historicoFiltrado.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(historicoFiltrado[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await _historicoBox.deleteAt(index);
                                  setState(() {
                                    historicoFiltrado.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(child: Text('Nenhum endereço no histórico')),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: limparHistorico,
              child: const Text('Limpar Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}