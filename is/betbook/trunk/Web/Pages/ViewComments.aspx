<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewComments.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.ViewComments" MasterPageFile="~/Betbook.Master" %>

<asp:Content ID="content1" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <br />
    <form runat="server">
        <p>
            <asp:Label ID="lblCommentsHeader" runat="server"></asp:Label>
        </p>
        <asp:GridView ID="gvEventComments" runat="server" CssClass="cooltable" GridLines="None"
                      AutoGenerateColumns="False" CellPadding="4">
            <Columns>
                <asp:BoundField DataField="date" meta:resourcekey="colDate" />
                <asp:TemplateField meta:resourcekey="colUser">
                    <ItemTemplate>
                        <asp:Label ID="lblUserName" runat="server"
                                   Text='<%# ((Es.Udc.DotNet.Betbook.Model.User)Eval("user")).login %>'></asp:Label> 
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="text" meta:resourcekey="colComment" />
                
                <asp:TemplateField meta:resourcekey="colTags">
                    <ItemTemplate>
                        <asp:ListView
                            ID="lvTagList" runat="server"
                            DataSource='<%# (System.Data.Objects.DataClasses.EntityCollection<Es.Udc.DotNet.Betbook.Model.Tag>)Eval("Tag") %>' >
                            <LayoutTemplate>
                                <div id="tagList">
                                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                                </div>
                            </LayoutTemplate>
                            
                            <ItemTemplate>
                                <ItemTemplate>
                                    <asp:HyperLink
                                        NavigateUrl='<%# "ViewComments.aspx?tag="+Eval("Text") %>'
                                        runat="server"
                                        Text='<%# Eval("Text") %>' />
                                </ItemTemplate>
                            </ItemTemplate>
                            
                            <EmptyDataTemplate>
                                <asp:Localize ID="lclNoTags" meta:resourcekey="lclNoTags" runat="server" />
                            </EmptyDataTemplate>
                        </asp:ListView>
                    </ItemTemplate>    
                </asp:TemplateField>
                
            </Columns>
        
        </asp:GridView>
    </form>
    <br />
    
    <!-- "Previous" and "Next" links. -->
    <div class="previousNextLinks">
        <span class="previousLink">
            <asp:HyperLink ID="lnkPrevious" Text="<%$ Resources:Common, Previous %>" runat="server"
                Visible="False"></asp:HyperLink>
        </span><span class="nextLink">
            <asp:HyperLink ID="lnkNext" Text="<%$ Resources:Common, Next %>" runat="server" Visible="False"></asp:HyperLink>
        </span>
    </div>
</asp:Content>
