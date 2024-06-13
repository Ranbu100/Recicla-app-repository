class TipoAjuda {
  TipoAjuda({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.isExpanded = false,
  });

  int id;
  String titulo;
  String descricao;
  bool isExpanded;

  static List<TipoAjuda> generateitems(int nunberofitems) {
    return List<TipoAjuda>.generate(nunberofitems, (int index) {
      return TipoAjuda(
        id: index + 1,
        titulo: "produto ${index + 1}",
        descricao: "esta é a descição ${index + 1}",
      );
    });
  }
}
/*
Expanded(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _products[index].isExpanded = !isExpanded;
                  });
                },
              ),
            ),
          ),
 */