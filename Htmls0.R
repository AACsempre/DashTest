#HTML code and other
welc_dash <- HTML('<div class="panel panel-default">
    <div style="background-color:#eaeaea">
    <div class="row">
    <div class="col-md-3">
    <img height="150" style="margin-bottom:-25px; margin-top:-25px; margin-left:10px" src="d_logo.png" />
    </div>
    <div class="col-md-9">
    <h4>Shinyapp Dashboard Test</h4>
    <h5><p>Lorem ipsum dolor sit amet, sensibus similique ea..</p>
    <p>Denique appellantur ius te, in eam sale magna. Ludus tation laboramus ex vis, mea invenire argumentum cu. Aperiri pertinax senserit ut mel, 
    eu vel quem vitae minimum, has ceteros indoctum ut. Simul possit his at. Iudicabit omittantur per ut, cu sit vidisse quaestio salutatus, no case ubique vix.</p></h5>
    <p style="display:inline-block"><a target="_blank" href="http://www.google.pt/" class="btn btn-default btn-sm">Read more &raquo;</a></p>
    </div>
    </div>
    </div>
    </div>')
docs_list0 <-HTML(' <h4><b>Documentation</b></h4>
                     <p><p>In this section you can find the main documentation regarding your instalation.</p></p>
                     <p></p>
                     <p>Solum ponderum no eum. Prima option et sed. Mea harum nostro ei, eu dico liber efficiantur cum. Vidit viris instructior vim in, ne aliquip temporibus cum. </p>
                     <div style="text-align:center"<p><i>At nihil rationibus sit, mei ea dicant tritani eripuit, te est suscipit vivendum splendide.</i></p></div>
                     ')

docs_list1 <-HTML(' <h3>General Documents</h3>
    <p></p>
    <dl>
    <dt>Installation Info</dt>
      <ul>
        <li> <a href="" target="_blank" >Install Main Doc.</a> </li>
        <li> <a href="" target="_blank" >Install Spec.  Doc.</a> </li>
      </ul>
    </dl> 
    <dl>
    <dt>Alert System</dt>
      <ul>  
        <li> No alert system implemented </li>
      </ul>  
    </dl> ')
docs_list2a <-  paste('<h3>Reports</h3> 
                      <p></p>   
                      <dl>     <dt>Main reports:</dt>      <ul>' )

#HTML - INSTALL CHARACTERISTICS
install_1 <- HTML('<div class="panel panel-default">
    <p> </p> 
    <p>- Name: Test Install 1 </p>
    <p>- Installation date: 2021/06 </p>
    <p>- Location: Somewhere, World </p>
    <p>- Status: In Progress </p>    
    </div>')
install_2 <- HTML('<div class="panel panel-default">
    <p> </p> 
    <p>- Name: Test Install 2 </p>
    <p>- Installation date: 2020/04 </p>
    <p>- Location: Somewhere Too, World </p>
    <p>- Status: In Progress </p>    
    </div>')

#FOOTER
footer_0 <- HTML('<footer>
             <p style="margin-top:5px; color: white; text-align:center; font-size: 12px"> 
             DashTest | 2021 Shiny Dashboard Test </p>
             </footer>')
