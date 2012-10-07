<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FindEvents.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.FindEvents"
    MasterPageFile="~/Betbook.Master" meta:resourcekey="Page" %>

<asp:Content ID="content1" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <asp:Label CssClass="errorMessage" ID="lblBetOMaticErrorMessage" runat="server"
        visible="false" meta:resourcekey="lblBetOMaticErrorMessage" />
    <div id="form">
        <form id="FindForm" method="post" runat="server">
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclKeywords" runat="server" meta:resourcekey="lblKeywords" />
            </span><span class="entry">
                <asp:TextBox ID="txtKeywords" runat="server" Width="200px" Columns="16" />
            </span>
        </div>
        <div class="button">
            <asp:CheckBox ID="checkNumberOfComments" runat="server" TextAlign="Right" meta:resourcekey="checkNumberOfComments" />
        </div>
        <div class="button">
            <asp:Button ID="btnFind" runat="server" meta:resourcekey="btnFind" OnClick="btnFind_Click" />
        </div>
        </form>
    </div>
    
    <asp:Xml ID="aspXml" runat="server" TransformSource="XSLT/FindEvents.xslt" />
    
</asp:Content>
