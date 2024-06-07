// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../logic/chart_data.dart';
import 'widgets.dart';

class DonutChartPage extends StatefulWidget {
  const DonutChartPage({super.key});

  @override
  _DonutChartPageState createState() => _DonutChartPageState();
}

class _DonutChartPageState extends State<DonutChartPage> {
  ScreenshotController screenshotController = ScreenshotController();
  int total = 0;
  List<PieChartSectionData> sections = ChartData.initialSections;

  @override
  void initState() {
    super.initState();
    total = ChartData.calculateTotal(sections);
  }

  void editValue(int index) {
    TextEditingController controller = TextEditingController();
    controller.text = sections[index]
        .value
        .toInt()
        .toString(); // Exibir valor como inteiro no campo de texto

    void save() {
      setState(() {
        final newValue =
            double.tryParse(controller.text) ?? sections[index].value;
        sections[index] =
            ChartData.updateSectionValue(sections[index], newValue);
        total = ChartData.calculateTotal(sections);
      });
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Valor'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Insira um novo valor"),
            onSubmitted: (value) => save(), // Ação ao pressionar Enter
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: save,
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gráfico para Sprints'),
        leading: Tooltip(
          message: "Sobre",
          child: IconButton(
            icon: const Icon(Icons.info), // Ícone para o botão à esquerda
            onPressed: () {
              // Ação ao clicar no botão
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GiffyDialog.image(
                    Image.network(
                      "https://i.pinimg.com/originals/ea/15/ad/ea15ad63ccc62fc94b077ad8761a7cc7.gif",
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    title: const Text(
                      'Gráfico para Sprints',
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      'Foi um prazer aprender a linguagem para fazer este aplicativo.\n Gabigol (Gamebielo)',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        actions: [
          Tooltip(
            message: "Exportar imagem",
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () async {
                final image = await screenshotController.capture();
                if (image == null) return;

                final directory = await FilePicker.platform.getDirectoryPath();
                if (directory == null) return;

                final filePath = '$directory/screenshot.png';
                final file = File(filePath);
                await file.writeAsBytes(image);

                OpenFile.open(filePath);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Tooltip(
                      message:
                          "Clique sobre o algum número para alterar.\nValor central é a quantidade total.",
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 40,
                          sectionsSpace: 0,
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event,
                                PieTouchResponse? pieTouchResponse) {
                              if (event is FlTapUpEvent) {
                                final index = pieTouchResponse
                                    ?.touchedSection?.touchedSectionIndex;
                                if (index != null) {
                                  editValue(index);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Tooltip(
                      message: "Tasks no backlog da sprint.",
                      child: buildLegend('Backlog', Colors.blue),
                    ),
                    Tooltip(
                      message: "Tasks em andamento.",
                      child: buildLegend('In Progress', Colors.orange),
                    ),
                    Tooltip(
                      message: "Tasks travadas ou em aguardo.",
                      child: buildLegend('On Hold', Colors.red),
                    ),
                    Tooltip(
                      message: "Tasks finalizadas.",
                      child: buildLegend('Done', Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
